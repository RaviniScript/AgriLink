import 'package:flutter/material.dart';
import 'package:agri_link/models/product_model.dart';
import 'package:agri_link/models/order_model.dart';
import 'package:agri_link/repository/product_repository.dart';
import 'package:agri_link/repository/order_repository.dart';

class BuyerViewModel extends ChangeNotifier {
  final ProductRepository _productRepository;
  final OrderRepository _orderRepository;

  List<ProductModel> _products = [];
  List<OrderModel> _orders = [];
  List<ProductModel> _cart = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ProductModel> get products => _products;
  List<OrderModel> get orders => _orders;
  List<ProductModel> get cart => _cart;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  BuyerViewModel(this._productRepository, this._orderRepository);

  Future<void> loadProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _products = await _productRepository.getAllProducts();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadProductsByCategory(String category) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _products = await _productRepository.getProductsByCategory(category);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadOrders(String buyerId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _orders = await _orderRepository.getOrdersByBuyerId(buyerId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void addToCart(ProductModel product, int quantity) {
    _cart.add(product);
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _cart.removeWhere((p) => p.id == productId);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  double getCartTotal() {
    return _cart.fold(0.0, (sum, product) => sum + product.price);
  }

  Future<bool> placeOrder(OrderModel order) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _orderRepository.createOrder(order);
      _orders.add(order);
      clearCart();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
