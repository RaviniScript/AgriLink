import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritesModel {
  final String id;
  final String buyerId;
  final String productId;
  final DateTime addedAt;

  FavoritesModel({
    required this.id,
    required this.buyerId,
    required this.productId,
    required this.addedAt,
  });

  // Create from Firestore document
  factory FavoritesModel.fromFirestore(
      Map<String, dynamic> data, String docId) {
    return FavoritesModel(
      id: docId,
      buyerId: data['buyerId'] ?? '',
      productId: data['productId'] ?? '',
      addedAt: (data['addedAt'] as Timestamp).toDate(),
    );
  }

  // Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'buyerId': buyerId,
      'productId': productId,
      'addedAt': Timestamp.fromDate(addedAt),
    };
  }

  // Copy with method
  FavoritesModel copyWith({
    String? id,
    String? buyerId,
    String? productId,
    DateTime? addedAt,
  }) {
    return FavoritesModel(
      id: id ?? this.id,
      buyerId: buyerId ?? this.buyerId,
      productId: productId ?? this.productId,
      addedAt: addedAt ?? this.addedAt,
    );
  }
}
