import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agri_link/models/cart_item_model.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'orders';

  Future<String> createOrder({
    required String buyerName,
    required String buyerPhone,
    required String deliveryAddress,
    required List<CartItem> items,
    required double subtotal,
    required double deliveryFee,
    required double total,
    required String paymentMethod,
    String? notes,
  }) async {
    try {
      print('🛒 Creating order for buyer: $buyerName');
      print('🛒 Total items in cart: ${items.length}');
      
      // Group items by farmer
      final Map<String, List<CartItem>> itemsByFarmer = {};
      for (var item in items) {
        final farmerId = item.product.farmerId;
        print('   - Product: ${item.product.name}, FarmerId: $farmerId');
        if (!itemsByFarmer.containsKey(farmerId)) {
          itemsByFarmer[farmerId] = [];
        }
        itemsByFarmer[farmerId]!.add(item);
      }

      print('🛒 Grouped into ${itemsByFarmer.length} farmer(s)');

      // Create separate orders for each farmer
      final List<String> orderIds = [];

      for (var entry in itemsByFarmer.entries) {
        final farmerId = entry.key;
        final farmerItems = entry.value;
        final farmerSubtotal = farmerItems.fold(
          0.0,
          (sum, item) => sum + item.totalPrice,
        );
        
        print('📝 Creating order for farmerId: $farmerId');

        final orderData = {
          'buyerName': buyerName,
          'buyerPhone': buyerPhone,
          'deliveryAddress': deliveryAddress,
          'farmerId': farmerId,
          'farmerName': farmerItems.first.product.farmerName,
          'items': farmerItems.map((item) => {
            'productId': item.product.id,
            'productName': item.product.name,
            'quantity': item.quantity,
            'price': item.product.price,
            'unit': item.product.unit,
            'imageUrl': item.product.imageUrl,
          }).toList(),
          'subtotal': farmerSubtotal,
          'deliveryFee': deliveryFee / itemsByFarmer.length, // Split delivery fee
          'total': farmerSubtotal + (deliveryFee / itemsByFarmer.length),
          'paymentMethod': paymentMethod,
          'notes': notes ?? '',
          'status': 'new', // new, pending, confirmed, preparing, ready, delivered, cancelled
          'orderDate': FieldValue.serverTimestamp(),
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        };

        final docRef = await _firestore.collection(_collection).add(orderData);
        orderIds.add(docRef.id);
        print('✅ Order created with ID: ${docRef.id} for farmer: $farmerId');
      }

      print('✅ All orders created successfully: ${orderIds.length} order(s)');
      // Return the first order ID (or could return all)
      return orderIds.first;
    } catch (e) {
      print('Error creating order: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getBuyerOrders(String buyerPhone) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('buyerPhone', isEqualTo: buyerPhone)
          .orderBy('orderDate', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print('Error fetching buyer orders: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getFarmerOrders(String farmerId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('farmerId', isEqualTo: farmerId)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print('Error fetching farmer orders: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> getOrderById(String orderId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(orderId).get();
      if (doc.exists) {
        final data = doc.data()!;
        data['id'] = doc.id;
        return data;
      }
      return null;
    } catch (e) {
      print('Error fetching order: $e');
      return null;
    }
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await _firestore.collection(_collection).doc(orderId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating order status: $e');
      rethrow;
    }
  }

  Stream<QuerySnapshot> streamBuyerOrders(String buyerPhone) {
    return _firestore
        .collection(_collection)
        .where('buyerPhone', isEqualTo: buyerPhone)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> streamFarmerOrders(String farmerId) {
    return _firestore
        .collection(_collection)
        .where('farmerId', isEqualTo: farmerId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
