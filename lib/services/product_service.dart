import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agri_link/models/product_model.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'products';

  // Get all products
  Future<List<ProductModel>> getAllProducts() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('isAvailable', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ProductModel.fromFirestore(
                doc.data() as Map<String, dynamic>,
                doc.id,
              ))
          .toList();
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }

  // Get products by category
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('category', isEqualTo: category.toLowerCase())
          .where('isAvailable', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ProductModel.fromFirestore(
                doc.data() as Map<String, dynamic>,
                doc.id,
              ))
          .toList();
    } catch (e) {
      print('Error fetching products by category: $e');
      return [];
    }
  }

  // Get best selling products (highest rated or most reviewed)
  Future<List<ProductModel>> getBestSellingProducts({int limit = 10}) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('isAvailable', isEqualTo: true)
          .orderBy('rating', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs
          .map((doc) => ProductModel.fromFirestore(
                doc.data() as Map<String, dynamic>,
                doc.id,
              ))
          .toList();
    } catch (e) {
      print('Error fetching best selling products: $e');
      return [];
    }
  }

  // Search products by name
  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      // Get all available products and filter on client side
      // This avoids needing additional Firebase composite indexes
      QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('isAvailable', isEqualTo: true)
          .get();

      final allProducts = snapshot.docs
          .map((doc) => ProductModel.fromFirestore(
                doc.data() as Map<String, dynamic>,
                doc.id,
              ))
          .toList();

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

  // Get products by farmer
  Future<List<ProductModel>> getProductsByFarmer(String farmerId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('farmerId', isEqualTo: farmerId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ProductModel.fromFirestore(
                doc.data() as Map<String, dynamic>,
                doc.id,
              ))
          .toList();
    } catch (e) {
      print('Error fetching products by farmer: $e');
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
