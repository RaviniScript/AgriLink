import 'package:cloud_firestore/cloud_firestore.dart';

class BuyerModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String profileImageUrl;
  final String defaultAddress;
  final String city;
  final String postalCode;
  final DateTime createdAt;
  final DateTime updatedAt;

  BuyerModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profileImageUrl = '',
    this.defaultAddress = '',
    this.city = '',
    this.postalCode = '',
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert from Firestore document
  factory BuyerModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return BuyerModel(
      id: docId,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      profileImageUrl: data['profileImageUrl'] ?? '',
      defaultAddress: data['defaultAddress'] ?? '',
      city: data['city'] ?? '',
      postalCode: data['postalCode'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'profileImageUrl': profileImageUrl,
      'defaultAddress': defaultAddress,
      'city': city,
      'postalCode': postalCode,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Copy with method for easy updates
  BuyerModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? profileImageUrl,
    String? defaultAddress,
    String? city,
    String? postalCode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BuyerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      defaultAddress: defaultAddress ?? this.defaultAddress,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
