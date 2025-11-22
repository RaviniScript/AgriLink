import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';
import '../models/crop_model.dart';

class ProductRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _products => _firestore.collection('products');
  CollectionReference get _crops => _firestore.collection('crops');

  // Get all products from both products and crops collections
  Future<List<ProductModel>> getAllProducts() async {
    List<ProductModel> allProducts = [];
    
    // Get from products collection
    final productsSnap = await _products.orderBy('name').get();
    allProducts.addAll(productsSnap.docs.map((d) => ProductModel.fromDocument(d)).toList());
    
    // Get from crops collection and convert to ProductModel
    final cropsSnap = await _crops.get();
    for (var doc in cropsSnap.docs) {
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
    
    // Sort by name
    allProducts.sort((a, b) => a.name.compareTo(b.name));
    return allProducts;
  }

  Future<List<ProductModel>> getProductsByCategory(String category) async {
    List<ProductModel> allProducts = [];
    
    // Get from products collection
    final productsSnap = await _products.where('category', isEqualTo: category).get();
    allProducts.addAll(productsSnap.docs.map((d) => ProductModel.fromDocument(d)).toList());
    
    // Get from crops collection with matching category (case-insensitive)
    final cropsSnap = await _crops.where('category', isEqualTo: category).get();
    for (var doc in cropsSnap.docs) {
      final crop = CropModel.fromDocument(doc);
      final farmerDoc = await _firestore.collection('users').doc(crop.ownerId).get();
      final farmerData = farmerDoc.data();
      final farmerName = farmerData?['firstName'] ?? 'Unknown';
      
      allProducts.add(ProductModel.fromCrop(
        crop,
        farmerName: farmerName,
        farmerLocation: crop.city,
      ));
    }
    
    return allProducts;
  }

  Future<void> createProduct(ProductModel product) async {
    await _products.add(product.toJson());
  }

  Future<void> updateProduct(ProductModel product) async {
    await _products.doc(product.id).update(product.toJson());
  }

  Future<void> deleteProduct(String id) async {
    await _products.doc(id).delete();
  }
}
