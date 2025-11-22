import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/payment_card_model.dart';

class PaymentCardRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add new payment card
  Future<void> addPaymentCard(PaymentCardModel card) async {
    try {
      await _firestore.collection('payment_cards').add(card.toJson());
    } catch (e) {
      throw Exception('Failed to add payment card: $e');
    }
  }

  // Get all payment cards for a user
  Future<List<PaymentCardModel>> getPaymentCards(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('payment_cards')
          .where('userId', isEqualTo: userId)
          .get();

      final cards = querySnapshot.docs
          .map((doc) => PaymentCardModel.fromDocument(doc))
          .toList();
      
      // Sort in memory instead of requiring Firestore index
      cards.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return cards;
    } catch (e) {
      throw Exception('Failed to get payment cards: $e');
    }
  }

  // Stream payment cards for real-time updates
  Stream<List<PaymentCardModel>> streamPaymentCards(String userId) {
    return _firestore
        .collection('payment_cards')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          final cards = snapshot.docs
              .map((doc) => PaymentCardModel.fromDocument(doc))
              .toList();
          // Sort in memory instead of requiring Firestore index
          cards.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return cards;
        });
  }

  // Delete payment card
  Future<void> deletePaymentCard(String cardId) async {
    try {
      await _firestore.collection('payment_cards').doc(cardId).delete();
    } catch (e) {
      throw Exception('Failed to delete payment card: $e');
    }
  }

  // Update payment card
  Future<void> updatePaymentCard(String cardId, PaymentCardModel card) async {
    try {
      await _firestore.collection('payment_cards').doc(cardId).update(card.toJson());
    } catch (e) {
      throw Exception('Failed to update payment card: $e');
    }
  }
}
