import 'package:cloud_firestore/cloud_firestore.dart';

class StockHistoryModel {
  final String id;
  final String farmerId;
  final String productId;
  final String productName;
  final String category; // vegetables, fruits
  final String imageUrl;
  final double initialStock;
  final double soldQuantity;
  final double remainingStock;
  final String unit;
  final String? orderId; // Reference to the order that caused this update
  final DateTime updatedAt;

  StockHistoryModel({
    required this.id,
    required this.farmerId,
    required this.productId,
    required this.productName,
    required this.category,
    required this.imageUrl,
    required this.initialStock,
    required this.soldQuantity,
    required this.remainingStock,
    required this.unit,
    this.orderId,
    required this.updatedAt,
  });

  factory StockHistoryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    
    return StockHistoryModel(
      id: doc.id,
      farmerId: data['farmerId'] ?? '',
      productId: data['productId'] ?? '',
      productName: data['productName'] ?? '',
      category: data['category'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      initialStock: (data['initialStock'] ?? 0).toDouble(),
      soldQuantity: (data['soldQuantity'] ?? 0).toDouble(),
      remainingStock: (data['remainingStock'] ?? 0).toDouble(),
      unit: data['unit'] ?? 'kg',
      orderId: data['orderId'],
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'farmerId': farmerId,
    'productId': productId,
    'productName': productName,
    'category': category,
    'imageUrl': imageUrl,
    'initialStock': initialStock,
    'soldQuantity': soldQuantity,
    'remainingStock': remainingStock,
    'unit': unit,
    'orderId': orderId,
    'updatedAt': FieldValue.serverTimestamp(),
  };

  // Create stock history from initial crop/product data
  factory StockHistoryModel.initial({
    required String farmerId,
    required String productId,
    required String productName,
    required String category,
    required String imageUrl,
    required double quantity,
    required String unit,
  }) {
    return StockHistoryModel(
      id: '',
      farmerId: farmerId,
      productId: productId,
      productName: productName,
      category: category,
      imageUrl: imageUrl,
      initialStock: quantity,
      soldQuantity: 0,
      remainingStock: quantity,
      unit: unit,
      updatedAt: DateTime.now(),
    );
  }

  // Create updated stock history when order is accepted
  StockHistoryModel copyWithSale({
    required double soldAmount,
    required String orderId,
  }) {
    return StockHistoryModel(
      id: id,
      farmerId: farmerId,
      productId: productId,
      productName: productName,
      category: category,
      imageUrl: imageUrl,
      initialStock: initialStock,
      soldQuantity: soldQuantity + soldAmount,
      remainingStock: remainingStock - soldAmount,
      unit: unit,
      orderId: orderId,
      updatedAt: DateTime.now(),
    );
  }
}
