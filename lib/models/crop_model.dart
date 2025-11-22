import 'package:cloud_firestore/cloud_firestore.dart';

class CropModel {
  final String id;
  final String ownerId;
  final String name;
  final String category;
  final double quantity;
  final double amount;
  final String imageUrl;
  final String city;
  final DateTime createdAt;

  CropModel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.category,
    required this.quantity,
    required this.amount,
    required this.imageUrl,
    required this.city,
    required this.createdAt,
  });

  factory CropModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return CropModel(
      id: doc.id,
      ownerId: data['ownerId'] ?? '',
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      quantity: (data['quantity'] ?? 0).toDouble(),
      amount: (data['amount'] ?? 0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      city: data['city'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ownerId': ownerId,
      'name': name,
      'category': category,
      'quantity': quantity,
      'amount': amount,
      'imageUrl': imageUrl,
      'city': city,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
