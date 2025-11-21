import 'package:flutter/foundation.dart';
import 'package:agri_link/models/cart_item_model.dart';
import 'package:agri_link/models/product_model.dart';

class CartService extends ChangeNotifier {
  // Singleton pattern
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.length;

  int get totalQuantity => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice => _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  // Add product to cart
  void addToCart(ProductModel product, {int quantity = 1}) {
    // Check if product already exists in cart
    final existingIndex = _items.indexWhere((item) => item.product.id == product.id);

    if (existingIndex >= 0) {
      // Update quantity if product exists
      _items[existingIndex] = CartItem(
        id: _items[existingIndex].id,
        product: product,
        quantity: _items[existingIndex].quantity + quantity,
      );
    } else {
      // Add new item to cart
      _items.add(CartItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        product: product,
        quantity: quantity,
      ));
    }

    notifyListeners();
  }

  // Update item quantity
  void updateQuantity(String itemId, int quantity) {
    if (quantity <= 0) {
      removeItem(itemId);
      return;
    }

    final index = _items.indexWhere((item) => item.id == itemId);
    if (index >= 0) {
      _items[index] = CartItem(
        id: _items[index].id,
        product: _items[index].product,
        quantity: quantity,
      );
      notifyListeners();
    }
  }

  // Increment quantity
  void incrementQuantity(String itemId) {
    final index = _items.indexWhere((item) => item.id == itemId);
    if (index >= 0) {
      updateQuantity(itemId, _items[index].quantity + 1);
    }
  }

  // Decrement quantity
  void decrementQuantity(String itemId) {
    final index = _items.indexWhere((item) => item.id == itemId);
    if (index >= 0) {
      updateQuantity(itemId, _items[index].quantity - 1);
    }
  }

  // Remove item from cart
  void removeItem(String itemId) {
    _items.removeWhere((item) => item.id == itemId);
    notifyListeners();
  }

  // Clear entire cart
  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  // Check if product is in cart
  bool isInCart(String productId) {
    return _items.any((item) => item.product.id == productId);
  }

  // Get quantity of specific product in cart
  int getProductQuantity(String productId) {
    final item = _items.firstWhere(
      (item) => item.product.id == productId,
      orElse: () => CartItem(
        id: '',
        product: ProductModel(
          id: '',
          name: '',
          description: '',
          price: 0,
          unit: '',
          category: '',
          imageUrl: '',
          farmerId: '',
          farmerName: '',
          farmerLocation: '',
          rating: 0,
          reviewCount: 0,
          isAvailable: false,
          stockQuantity: 0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        quantity: 0,
      ),
    );
    return item.quantity;
  }
}
