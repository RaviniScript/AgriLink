import 'package:agri_link/models/product_model.dart';

abstract class ProductRepository {
  Future<List<ProductModel>> getAllProducts();
  Future<List<ProductModel>> getProductsByCategory(String category);
  Future<ProductModel> getProductById(String id);
  Future<List<ProductModel>> getProductsByFarmerId(String farmerId);
  Future<ProductModel> createProduct(ProductModel product);
  Future<ProductModel> updateProduct(ProductModel product);
  Future<void> deleteProduct(String id);
}

class ProductRepositoryImpl implements ProductRepository {
  @override
  Future<List<ProductModel>> getAllProducts() async {
    // TODO: Implement get all products
    throw UnimplementedError();
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    // TODO: Implement get products by category
    throw UnimplementedError();
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    // TODO: Implement get product by id
    throw UnimplementedError();
  }

  @override
  Future<List<ProductModel>> getProductsByFarmerId(String farmerId) async {
    // TODO: Implement get products by farmer id
    throw UnimplementedError();
  }

  @override
  Future<ProductModel> createProduct(ProductModel product) async {
    // TODO: Implement create product
    throw UnimplementedError();
  }

  @override
  Future<ProductModel> updateProduct(ProductModel product) async {
    // TODO: Implement update product
    throw UnimplementedError();
  }

  @override
  Future<void> deleteProduct(String id) async {
    // TODO: Implement delete product
    throw UnimplementedError();
  }
}
