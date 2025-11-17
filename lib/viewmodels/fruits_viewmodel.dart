import 'package:flutter/material.dart';
import 'package:agri_link/models/product_model.dart';
import 'package:agri_link/repository/product_repository.dart';

class FruitsViewModel extends ChangeNotifier {
  final ProductRepository _productRepository;

  List<ProductModel> _fruits = [];
  ProductModel? _selectedFruit;
  bool _isLoading = false;
  String? _errorMessage;

  List<ProductModel> get fruits => _fruits;
  ProductModel? get selectedFruit => _selectedFruit;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  FruitsViewModel(this._productRepository);

  Future<void> loadFruits() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _fruits = await _productRepository.getProductsByCategory('fruits');
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectFruit(ProductModel fruit) {
    _selectedFruit = fruit;
    notifyListeners();
  }

  void clearSelection() {
    _selectedFruit = null;
    notifyListeners();
  }
}
