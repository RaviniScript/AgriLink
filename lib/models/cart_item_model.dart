import 'product_model.dart';

class CartItem {
  final String id;
  final ProductModel product;
  int quantity;

  CartItem({
    required this.id,
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;

  CartItem copyWith({
    String? id,
    ProductModel? product,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  // Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'productId': product.id,
      'quantity': quantity,
    };
  }

  // Convert from Firestore document (requires product to be fetched separately)
  factory CartItem.fromFirestore(Map<String, dynamic> data, ProductModel product, String docId) {
    return CartItem(
      id: docId,
      product: product,
      quantity: data['quantity'] ?? 1,
    );
  }
}
