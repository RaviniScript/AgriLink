import 'package:flutter/material.dart';
import 'package:agri_link/models/product_model.dart';
import 'package:agri_link/repository/product_repository.dart';

class VegetablesViewModel extends ChangeNotifier {
  final ProductRepository _productRepository;

  List<ProductModel> _vegetables = [];
  ProductModel? _selectedVegetable;
  bool _isLoading = false;
  String? _errorMessage;

  List<ProductModel> get vegetables => _vegetables;
  ProductModel? get selectedVegetable => _selectedVegetable;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  VegetablesViewModel(this._productRepository);

  Future<void> loadVegetables() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _vegetables = await _productRepository.getProductsByCategory('vegetables');
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectVegetable(ProductModel vegetable) {
    _selectedVegetable = vegetable;
    notifyListeners();
  }

  void clearSelection() {
    _selectedVegetable = null;
    notifyListeners();
  }
}
