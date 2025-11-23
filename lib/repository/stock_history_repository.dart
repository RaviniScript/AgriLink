import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/stock_history_model.dart';
import '../models/crop_model.dart';

class StockHistoryRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  CollectionReference get _stockHistory => _firestore.collection('stock_history');
  CollectionReference get _crops => _firestore.collection('crops');

  // Get stock history for a farmer grouped by product
  Future<Map<String, StockHistoryModel>> getFarmerStockHistory(String farmerId) async {
    try {
      final Map<String, StockHistoryModel> stockMap = {};

      // Get all crops for this farmer
      final cropsSnapshot = await _crops.where('ownerId', isEqualTo: farmerId).get();
      
      for (var cropDoc in cropsSnapshot.docs) {
        final crop = CropModel.fromDocument(cropDoc);
        
        // Check if stock history exists for this product
        final historySnapshot = await _stockHistory
            .where('farmerId', isEqualTo: farmerId)
            .where('productId', isEqualTo: cropDoc.id)
            .limit(1)
            .get();

        if (historySnapshot.docs.isEmpty) {
          // Create initial stock history entry
          final initialHistory = StockHistoryModel.initial(
            farmerId: farmerId,
            productId: cropDoc.id,
            productName: crop.name,
            category: crop.category,
            imageUrl: crop.imageUrl,
            quantity: crop.quantity,
            unit: crop.unit,
          );
          
          // Save to database
          await _stockHistory.add(initialHistory.toJson());
          stockMap[cropDoc.id] = initialHistory;
        } else {
          // Use existing history
          stockMap[cropDoc.id] = StockHistoryModel.fromFirestore(historySnapshot.docs.first);
        }
      }

      return stockMap;
    } catch (e) {
      print('Error fetching stock history: $e');
      return {};
    }
  }

  // Get stock history by category (vegetables or fruits)
  Future<List<StockHistoryModel>> getFarmerStockByCategory(String farmerId, String category) async {
    try {
      // First get the stock history map
      final stockMap = await getFarmerStockHistory(farmerId);
      
      // Filter by category
      return stockMap.values
          .where((stock) => stock.category.toLowerCase() == category.toLowerCase())
          .toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt)); // Most recent first
    } catch (e) {
      print('Error fetching stock by category: $e');
      return [];
    }
  }

  // Stream stock history for real-time updates
  Stream<QuerySnapshot> streamFarmerStock(String farmerId) {
    return _stockHistory
        .where('farmerId', isEqualTo: farmerId)
        .snapshots();
  }

  // Update stock when order is accepted
  Future<void> updateStockOnOrderAccepted({
    required String orderId,
    required String farmerId,
    required List<Map<String, dynamic>> orderItems,
  }) async {
    try {
      print('📦 Updating stock for order: $orderId');
      print('📦 FarmerId: $farmerId');
      print('📦 Number of items: ${orderItems.length}');

      for (var item in orderItems) {
        final productId = item['productId'] as String?;
        final quantity = (item['quantity'] as num?)?.toDouble() ?? 0;
        final productName = item['productName'] as String? ?? 'Unknown';

        if (productId == null || quantity <= 0) {
          print('   ⚠️ Skipping invalid item: productId=$productId, quantity=$quantity');
          continue;
        }

        print('   🔍 Processing: $productName (ID: $productId), Qty: $quantity');

        // Get current stock history
        final historySnapshot = await _stockHistory
            .where('farmerId', isEqualTo: farmerId)
            .where('productId', isEqualTo: productId)
            .limit(1)
            .get();

        if (historySnapshot.docs.isNotEmpty) {
          // Update existing history
          final currentDoc = historySnapshot.docs.first;
          final currentHistory = StockHistoryModel.fromFirestore(currentDoc);
          
          print('   📊 Current stock: ${currentHistory.remainingStock} ${currentHistory.unit}');
          print('   📊 Sold quantity: ${currentHistory.soldQuantity} ${currentHistory.unit}');
          
          final updatedHistory = currentHistory.copyWithSale(
            soldAmount: quantity,
            orderId: orderId,
          );

          await _stockHistory.doc(currentDoc.id).update(updatedHistory.toJson());
          
          // Also update the crop quantity
          final cropDoc = await _crops.doc(productId).get();
          if (cropDoc.exists) {
            await _crops.doc(productId).update({
              'quantity': updatedHistory.remainingStock,
              'updatedAt': FieldValue.serverTimestamp(),
            });
            print('   ✅ Stock updated: ${updatedHistory.remainingStock} ${updatedHistory.unit} remaining (Sold: ${updatedHistory.soldQuantity})');
          } else {
            print('   ⚠️ Crop document not found: $productId');
          }
        } else {
          print('   ⚠️ No stock history found for product: $productId');
          print('   💡 Creating initial stock history...');
          
          // Try to get crop data to create initial history
          final cropDoc = await _crops.doc(productId).get();
          if (cropDoc.exists) {
            final cropData = cropDoc.data() as Map<String, dynamic>;
            final initialStock = (cropData['quantity'] as num?)?.toDouble() ?? 0;
            
            final newHistory = StockHistoryModel(
              id: '',
              farmerId: farmerId,
              productId: productId,
              productName: productName,
              category: cropData['category'] ?? 'Unknown',
              imageUrl: cropData['imageUrl'] ?? '',
              initialStock: initialStock,
              soldQuantity: quantity,
              remainingStock: initialStock - quantity,
              unit: cropData['unit'] ?? 'kg',
              orderId: orderId,
              updatedAt: DateTime.now(),
            );
            
            await _stockHistory.add(newHistory.toJson());
            await _crops.doc(productId).update({
              'quantity': newHistory.remainingStock,
              'updatedAt': FieldValue.serverTimestamp(),
            });
            
            print('   ✅ Created new stock history and updated crop');
          }
        }
      }

      print('✅ Stock update completed for order: $orderId');
    } catch (e) {
      print('❌ Error updating stock: $e');
      rethrow;
    }
  }

  // Reset or manually adjust stock
  Future<void> resetStock({
    required String farmerId,
    required String productId,
    required double newQuantity,
  }) async {
    try {
      final historySnapshot = await _stockHistory
          .where('farmerId', isEqualTo: farmerId)
          .where('productId', isEqualTo: productId)
          .limit(1)
          .get();

      if (historySnapshot.docs.isNotEmpty) {
        final docId = historySnapshot.docs.first.id;
        final current = StockHistoryModel.fromFirestore(historySnapshot.docs.first);
        
        await _stockHistory.doc(docId).update({
          'initialStock': newQuantity,
          'remainingStock': newQuantity,
          'soldQuantity': 0,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        // Update crop as well
        await _crops.doc(productId).update({
          'quantity': newQuantity,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error resetting stock: $e');
      rethrow;
    }
  }
}
