import 'package:cloud_firestore/cloud_firestore.dart';

class CropModel {
  final String id;
  final String ownerId;
  final String name;
  final String category;
  final double quantity;
  final String unit; // Unit of measurement (kg/g)
  final double amount;
  final String imageUrl; // Main image (kept for backward compatibility)
  final List<String> imageUrls; // Multiple images support
  final String city;
  final DateTime createdAt;

  CropModel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.category,
    required this.quantity,
    this.unit = 'kg', // Default unit
    required this.amount,
    required this.imageUrl,
    List<String>? imageUrls,
    required this.city,
    required this.createdAt,
  }) : imageUrls = imageUrls ?? [imageUrl];

  factory CropModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    
    // Handle both single imageUrl and multiple imageUrls
    final String mainImageUrl = data['imageUrl'] ?? '';
    final List<String> imageUrlsList = data['imageUrls'] != null 
        ? List<String>.from(data['imageUrls']) 
        : (mainImageUrl.isNotEmpty ? [mainImageUrl] : []);
    
    return CropModel(
      id: doc.id,
      ownerId: data['ownerId'] ?? '',
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      quantity: (data['quantity'] ?? 0).toDouble(),
      unit: data['unit'] ?? 'kg',
      amount: (data['amount'] ?? 0).toDouble(),
      imageUrl: mainImageUrl,
      imageUrls: imageUrlsList,
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
      'unit': unit,
      'amount': amount,
      'imageUrl': imageUrl,
      'imageUrls': imageUrls,
      'city': city,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
