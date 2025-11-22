import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String id;
  final String orderId;
  final String productId;
  final String buyerId;
  final String buyerName;
  final double rating; // 1.0 to 5.0
  final String reviewText;
  final List<String> imageUrls;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ReviewModel({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.buyerId,
    required this.buyerName,
    required this.rating,
    required this.reviewText,
    this.imageUrls = const [],
    required this.createdAt,
    this.updatedAt,
  });

  // Factory constructor to create ReviewModel from Firestore document
  factory ReviewModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return ReviewModel(
      id: docId,
      orderId: data['orderId'] ?? '',
      productId: data['productId'] ?? '',
      buyerId: data['buyerId'] ?? '',
      buyerName: data['buyerName'] ?? 'Anonymous',
      rating: (data['rating'] ?? 0.0).toDouble(),
      reviewText: data['reviewText'] ?? '',
      imageUrls: data['imageUrls'] != null 
          ? List<String>.from(data['imageUrls']) 
          : [],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  // Convert ReviewModel to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'orderId': orderId,
      'productId': productId,
      'buyerId': buyerId,
      'buyerName': buyerName,
      'rating': rating,
      'reviewText': reviewText,
      'imageUrls': imageUrls,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  // Create a copy with modified fields
  ReviewModel copyWith({
    String? id,
    String? orderId,
    String? productId,
    String? buyerId,
    String? buyerName,
    double? rating,
    String? reviewText,
    List<String>? imageUrls,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      productId: productId ?? this.productId,
      buyerId: buyerId ?? this.buyerId,
      buyerName: buyerName ?? this.buyerName,
      rating: rating ?? this.rating,
      reviewText: reviewText ?? this.reviewText,
      imageUrls: imageUrls ?? this.imageUrls,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
