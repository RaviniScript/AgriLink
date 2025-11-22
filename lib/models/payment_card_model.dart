import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentCardModel {
  final String id;
  final String userId;
  final String cardHolderName;
  final String cardNumber; // Store encrypted in production
  final String expiryMonth;
  final String expiryYear;
  final String cvv; // Store encrypted in production
  final String cardType;
  final DateTime createdAt;

  PaymentCardModel({
    required this.id,
    required this.userId,
    required this.cardHolderName,
    required this.cardNumber,
    required this.expiryMonth,
    required this.expiryYear,
    required this.cvv,
    required this.cardType,
    required this.createdAt,
  });

  String get maskedCardNumber {
    if (cardNumber.length >= 4) {
      return '•••• •••• •••• ${cardNumber.substring(cardNumber.length - 4)}';
    }
    return cardNumber;
  }

  factory PaymentCardModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PaymentCardModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      cardHolderName: data['cardHolderName'] ?? '',
      cardNumber: data['cardNumber'] ?? '',
      expiryMonth: data['expiryMonth'] ?? '',
      expiryYear: data['expiryYear'] ?? '',
      cvv: data['cvv'] ?? '',
      cardType: data['cardType'] ?? 'visa',
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'cardHolderName': cardHolderName,
      'cardNumber': cardNumber,
      'expiryMonth': expiryMonth,
      'expiryYear': expiryYear,
      'cvv': cvv,
      'cardType': cardType,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
