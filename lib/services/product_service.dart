import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agri_link/models/product_model.dart';
import 'package:agri_link/models/crop_model.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'products';
  final String _cropsCollection = 'crops';

  // Get all products from both products and crops collections
  Future<List<ProductModel>> getAllProducts() async {
    try {
      List<ProductModel> allProducts = [];
      
      // Get from products collection
      QuerySnapshot productsSnapshot = await _firestore
          .collection(_collection)
          .where('isAvailable', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      allProducts.addAll(productsSnapshot.docs
          .map((doc) => ProductModel.fromFirestore(
                doc.data() as Map<String, dynamic>,
                doc.id,
              ))
          .toList());
      
      // Get from crops collection and convert to ProductModel
      QuerySnapshot cropsSnapshot = await _firestore
          .collection(_cropsCollection)
          .get();
      
      for (var doc in cropsSnapshot.docs) {
        final crop = CropModel.fromDocument(doc);
        // Fetch farmer name from users collection
        final farmerDoc = await _firestore.collection('users').doc(crop.ownerId).get();
        final farmerData = farmerDoc.data();
        final farmerName = farmerData?['firstName'] ?? 'Unknown';
        
        allProducts.add(ProductModel.fromCrop(
          crop,
          farmerName: farmerName,
          farmerLocation: crop.city,
        ));
      }
      
      // Sort by createdAt descending
      allProducts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      return allProducts;
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }

  // Get products by category from both products and crops collections
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    try {
      List<ProductModel> allProducts = [];
      
      print('🔍 Fetching products for category: $category');
      
      // Get from products collection
      QuerySnapshot productsSnapshot = await _firestore
          .collection(_collection)
          .where('category', isEqualTo: category.toLowerCase())
          .where('isAvailable', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      print('📦 Found ${productsSnapshot.docs.length} products from products collection');
      
      allProducts.addAll(productsSnapshot.docs
          .map((doc) => ProductModel.fromFirestore(
                doc.data() as Map<String, dynamic>,
                doc.id,
              ))
          .toList());
      
      // Get from crops collection with matching category
      QuerySnapshot cropsSnapshot = await _firestore
          .collection(_cropsCollection)
          .where('category', isEqualTo: category.toLowerCase())
          .get();
      
      print('🌾 Found ${cropsSnapshot.docs.length} crops from crops collection for category: ${category.toLowerCase()}');
      
      for (var doc in cropsSnapshot.docs) {
        final crop = CropModel.fromDocument(doc);
        print('🌱 Processing crop: ${crop.name}, category: ${crop.category}');
        
        // Fetch farmer name from users collection
        final farmerDoc = await _firestore.collection('users').doc(crop.ownerId).get();
        final farmerData = farmerDoc.data();
        final farmerName = farmerData?['firstName'] ?? 'Unknown';
        
        print('👨‍🌾 Farmer: $farmerName, Location: ${crop.city}');
        
        allProducts.add(ProductModel.fromCrop(
          crop,
          farmerName: farmerName,
          farmerLocation: crop.city,
        ));
      }
      
      print('✅ Total products found: ${allProducts.length}');
      
      // Sort by createdAt descending
      allProducts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      return allProducts;
    } catch (e) {
      print('❌ Error fetching products by category: $e');
      return [];
    }
  }

  // Get best selling products based on order frequency
  Future<List<ProductModel>> getBestSellingProducts({int limit = 10}) async {
    try {
      // Get all orders to count product purchases
      final ordersSnapshot = await _firestore.collection('orders').get();
      
      // Count occurrences of each product
      Map<String, int> productOrderCounts = {};
      Map<String, String> productNames = {}; // Store product names
      
      for (var orderDoc in ordersSnapshot.docs) {
        final orderData = orderDoc.data();
        final items = orderData['items'] as List<dynamic>?;
        
        if (items != null) {
          for (var item in items) {
            final productId = item['productId'] as String?;
            final productName = item['productName'] as String?;
            final quantity = (item['quantity'] as num?)?.toInt() ?? 1;
            
            if (productId != null && productName != null) {
              productOrderCounts[productName] = (productOrderCounts[productName] ?? 0) + quantity;
              productNames[productName] = productName;
            }
          }
        }
      }
      
      // Sort products by order count
      final sortedProducts = productOrderCounts.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      
      // Get actual product details for top products
      List<ProductModel> bestSelling = [];
      
      for (var entry in sortedProducts.take(limit)) {
        final productName = entry.key;
        
        // Try to find in products collection first
        final productsQuery = await _firestore
            .collection(_collection)
            .where('name', isEqualTo: productName)
            .where('isAvailable', isEqualTo: true)
            .limit(1)
            .get();
        
        if (productsQuery.docs.isNotEmpty) {
          final doc = productsQuery.docs.first;
          bestSelling.add(ProductModel.fromFirestore(
            doc.data(),
            doc.id,
          ));
        } else {
          // Try crops collection
          final cropsQuery = await _firestore
              .collection(_cropsCollection)
              .where('name', isEqualTo: productName)
              .limit(1)
              .get();
          
          if (cropsQuery.docs.isNotEmpty) {
            final doc = cropsQuery.docs.first;
            final crop = CropModel.fromDocument(doc);
            
            // Fetch farmer name
            final farmerDoc = await _firestore.collection('users').doc(crop.ownerId).get();
            final farmerData = farmerDoc.data();
            final farmerName = farmerData?['firstName'] ?? 'Unknown';
            
            bestSelling.add(ProductModel.fromCrop(
              crop,
              farmerName: farmerName,
              farmerLocation: crop.city,
            ));
          }
        }
      }
      
      // If no orders yet, fallback to newest products
      if (bestSelling.isEmpty) {
        final snapshot = await _firestore
            .collection(_collection)
            .where('isAvailable', isEqualTo: true)
            .orderBy('createdAt', descending: true)
            .limit(limit)
            .get();

        bestSelling = snapshot.docs
            .map((doc) => ProductModel.fromFirestore(
                  doc.data(),
                  doc.id,
                ))
            .toList();
      }
      
      return bestSelling;
    } catch (e) {
      print('Error fetching best selling products: $e');
      // Fallback to newest products
      try {
        final snapshot = await _firestore
            .collection(_collection)
            .where('isAvailable', isEqualTo: true)
            .orderBy('createdAt', descending: true)
            .limit(limit)
            .get();

        return snapshot.docs
            .map((doc) => ProductModel.fromFirestore(
                  doc.data(),
                  doc.id,
                ))
            .toList();
      } catch (fallbackError) {
        print('Error in fallback: $fallbackError');
        return [];
      }
    }
  }

  // Search products by name
  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      List<ProductModel> allProducts = [];
      
      // Search in products collection
      QuerySnapshot productsSnapshot = await _firestore
          .collection(_collection)
          .where('isAvailable', isEqualTo: true)
          .get();

      allProducts.addAll(productsSnapshot.docs
          .map((doc) => ProductModel.fromFirestore(
                doc.data() as Map<String, dynamic>,
                doc.id,
              ))
          .toList());
      
      // Search in crops collection
      QuerySnapshot cropsSnapshot = await _firestore
          .collection(_cropsCollection)
          .get();
      
      for (var doc in cropsSnapshot.docs) {
        final crop = CropModel.fromDocument(doc);
        // Fetch farmer name from users collection
        final farmerDoc = await _firestore.collection('users').doc(crop.ownerId).get();
        final farmerData = farmerDoc.data();
        final farmerName = farmerData?['firstName'] ?? 'Unknown';
        
        allProducts.add(ProductModel.fromCrop(
          crop,
          farmerName: farmerName,
          farmerLocation: crop.city,
        ));
      }

      // Filter products by name (case-insensitive)
      final searchTerm = query.toLowerCase();
      return allProducts.where((product) {
        return product.name.toLowerCase().contains(searchTerm);
      }).toList();
    } catch (e) {
      print('Error searching products: $e');
      return [];
    }
  }

  // Get product by ID
  Future<ProductModel?> getProductById(String productId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(_collection)
          .doc(productId)
          .get();

      if (doc.exists) {
        return ProductModel.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }
      return null;
    } catch (e) {
      print('Error fetching product by ID: $e');
      return null;
    }
  }

  // Get products by farmer (from both products and crops collections)
  Future<List<ProductModel>> getProductsByFarmer(String farmerId) async {
    try {
      print('🔍 Fetching all products for farmer: $farmerId');
      
      final List<ProductModel> allProducts = [];
      
      // 1. Fetch from products collection
      QuerySnapshot productsSnapshot = await _firestore
          .collection(_collection)
          .where('farmerId', isEqualTo: farmerId)
          .get();
      
      print('📦 Found ${productsSnapshot.docs.length} products from products collection');
      
      for (var doc in productsSnapshot.docs) {
        allProducts.add(ProductModel.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        ));
      }
      
      // 2. Fetch from crops collection (uses 'ownerId' field, not 'farmerId')
      QuerySnapshot cropsSnapshot = await _firestore
          .collection('crops')
          .where('ownerId', isEqualTo: farmerId)
          .get();
      
      print('🌾 Found ${cropsSnapshot.docs.length} crops from crops collection');
      
      // Get farmer details for crop conversion
      final farmerDoc = await _firestore.collection('users').doc(farmerId).get();
      final farmerData = farmerDoc.data();
      final farmerName = farmerData?['name'] ?? 'Unknown';
      final farmerLocation = farmerData?['location'] ?? 'Unknown';
      
      for (var doc in cropsSnapshot.docs) {
        final crop = CropModel.fromDocument(doc);
        
        print('🌱 Processing crop: ${crop.name}, category: ${crop.category}');
        
        // Convert CropModel to ProductModel
        final product = ProductModel.fromCrop(crop, farmerName: farmerName, farmerLocation: farmerLocation);
        allProducts.add(product);
      }
      
      print('✅ Total products found for farmer: ${allProducts.length}');
      return allProducts;
    } catch (e) {
      print('❌ Error fetching products by farmer: $e');
      return [];
    }
  }

  // Stream products (for real-time updates)
  Stream<List<ProductModel>> streamProducts() {
    return _firestore
        .collection(_collection)
        .where('isAvailable', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ProductModel.fromFirestore(
                  doc.data(),
                  doc.id,
                ))
            .toList());
  }
}
