import 'package:agri_link/models/category_model.dart';

abstract class CategoryRepository {
  Future<List<CategoryModel>> getAllCategories();
  Future<CategoryModel> getCategoryById(String id);
  Future<CategoryModel> createCategory(CategoryModel category);
  Future<CategoryModel> updateCategory(CategoryModel category);
  Future<void> deleteCategory(String id);
}

class CategoryRepositoryImpl implements CategoryRepository {
  @override
  Future<List<CategoryModel>> getAllCategories() async {
    // TODO: Implement get all categories
    throw UnimplementedError();
  }

  @override
  Future<CategoryModel> getCategoryById(String id) async {
    // TODO: Implement get category by id
    throw UnimplementedError();
  }

  @override
  Future<CategoryModel> createCategory(CategoryModel category) async {
    // TODO: Implement create category
    throw UnimplementedError();
  }

  @override
  Future<CategoryModel> updateCategory(CategoryModel category) async {
    // TODO: Implement update category
    throw UnimplementedError();
  }

  @override
  Future<void> deleteCategory(String id) async {
    // TODO: Implement delete category
    throw UnimplementedError();
  }
}