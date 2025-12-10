import 'package:cloud_firestore/cloud_firestore.dart';
import 'crop_model.dart';

class ProductModel {
  final String id;
  final String name;
  final String? description;
  final double price;
  final String unit; // kg, g, bunch, piece, etc.
  final String category; // vegetables, fruits
  final String imageUrl;
  final List<String> imageUrls; // Multiple images support
  final String farmerId;
  final String farmerName;
  final String farmerLocation;
  final double rating;
  final int reviewCount;
  final bool isAvailable;
  final int stockQuantity;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductModel({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.unit,
    required this.category,
    required this.imageUrl,
    List<String>? imageUrls,
    required this.farmerId,
    required this.farmerName,
    required this.farmerLocation,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isAvailable = true,
    required this.stockQuantity,
    required this.createdAt,
    required this.updatedAt,
  }) : imageUrls = imageUrls ?? [imageUrl];

  // Convert from Firestore document
  factory ProductModel.fromFirestore(Map<String, dynamic> data, String docId) {
    final String mainImageUrl = data['imageUrl'] ?? '';
    final List<String> imageUrlsList = data['imageUrls'] != null 
        ? List<String>.from(data['imageUrls']) 
        : (mainImageUrl.isNotEmpty ? [mainImageUrl] : []);
        
    return ProductModel(
      id: docId,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      unit: data['unit'] ?? 'kg',
      category: data['category'] ?? '',
      imageUrl: mainImageUrl,
      imageUrls: imageUrlsList,
      farmerId: data['farmerId'] ?? '',
      farmerName: data['farmerName'] ?? '',
      farmerLocation: data['farmerLocation'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
      reviewCount: data['reviewCount'] ?? 0,
      isAvailable: data['isAvailable'] ?? true,
      stockQuantity: data['stockQuantity'] ?? 0,
      createdAt: data['createdAt']?.toDate() ?? DateTime.now(),
      updatedAt: data['updatedAt']?.toDate() ?? DateTime.now(),
    );
  }

  // Convert from CropModel (farmer's crops to buyer's products)
  factory ProductModel.fromCrop(CropModel crop, {String? farmerName, String? farmerLocation}) {
    return ProductModel(
      id: crop.id,
      name: crop.name,
      description: null,
      price: crop.amount,
      unit: crop.unit,
      category: crop.category,
      imageUrl: crop.imageUrl,
      imageUrls: crop.imageUrls,
      farmerId: crop.ownerId,
      farmerName: farmerName ?? 'Unknown Farmer',
      farmerLocation: farmerLocation ?? crop.city,
      rating: 0.0,
      reviewCount: 0,
      isAvailable: true,
      stockQuantity: crop.quantity.toInt(),
      createdAt: crop.createdAt,
      updatedAt: crop.createdAt,
    );
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      unit: json['unit'] ?? 'kg',
      category: json['category'],
      imageUrl: json['imageUrl'] ?? '',
      farmerId: json['farmerId'],
      farmerName: json['farmerName'] ?? '',
      farmerLocation: json['farmerLocation'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      isAvailable: json['isAvailable'] ?? true,
      stockQuantity: json['stockQuantity'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  factory ProductModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return ProductModel.fromFirestore(data, doc.id);
  }

  // Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'unit': unit,
      'category': category,
      'imageUrl': imageUrl,
      'farmerId': farmerId,
      'farmerName': farmerName,
      'farmerLocation': farmerLocation,
      'rating': rating,
      'reviewCount': reviewCount,
      'isAvailable': isAvailable,
      'stockQuantity': stockQuantity,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'unit': unit,
      'category': category,
      'imageUrl': imageUrl,
      'farmerId': farmerId,
      'farmerName': farmerName,
      'farmerLocation': farmerLocation,
      'rating': rating,
      'reviewCount': reviewCount,
      'isAvailable': isAvailable,
      'stockQuantity': stockQuantity,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
