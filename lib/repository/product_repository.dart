import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _products => _firestore.collection('products');

  Future<List<ProductModel>> getAllProducts() async {
    final snap = await _products.orderBy('name').get();
    return snap.docs.map((d) => ProductModel.fromDocument(d)).toList();
  }

  Future<List<ProductModel>> getProductsByCategory(String category) async {
    final snap = await _products.where('category', isEqualTo: category).get();
    return snap.docs.map((d) => ProductModel.fromDocument(d)).toList();
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
