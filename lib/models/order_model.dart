class OrderModel {
  final String id;
  final String buyerId;
  final String farmerId;
  final List<OrderItem> items;
  final double totalAmount;
  final String status; // 'pending', 'confirmed', 'delivered', 'cancelled'
  final DateTime orderDate;
  final DateTime? deliveryDate;
  final String? deliveryPersonId;

  OrderModel({
    required this.id,
    required this.buyerId,
    required this.farmerId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.orderDate,
    this.deliveryDate,
    this.deliveryPersonId,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      buyerId: json['buyerId'],
      farmerId: json['farmerId'],
      items: List<OrderItem>.from(
        (json['items'] as List).map((x) => OrderItem.fromJson(x)),
      ),
      totalAmount: json['totalAmount'],
      status: json['status'],
      orderDate: DateTime.parse(json['orderDate']),
      deliveryDate: json['deliveryDate'] != null
          ? DateTime.parse(json['deliveryDate'])
          : null,
      deliveryPersonId: json['deliveryPersonId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'buyerId': buyerId,
      'farmerId': farmerId,
      'items': items.map((x) => x.toJson()).toList(),
      'totalAmount': totalAmount,
      'status': status,
      'orderDate': orderDate.toIso8601String(),
      'deliveryDate': deliveryDate?.toIso8601String(),
      'deliveryPersonId': deliveryPersonId,
    };
  }
}

class OrderItem {
  final String productId;
  final int quantity;
  final double price;

  OrderItem({
    required this.productId,
    required this.quantity,
    required this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'],
      quantity: json['quantity'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
      'price': price,
    };
  }
}
