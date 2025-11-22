import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/payment_card_model.dart';
import '../repository/payment_card_repository.dart';

class PaymentCardViewModel extends ChangeNotifier {
  final PaymentCardRepository _repository;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<PaymentCardModel> _cards = [];
  bool _isLoading = false;
  String? _errorMessage;

  PaymentCardViewModel({PaymentCardRepository? repository})
      : _repository = repository ?? PaymentCardRepository();

  List<PaymentCardModel> get cards => _cards;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get currentUserId => _auth.currentUser?.uid;

  // Load payment cards
  Future<void> loadPaymentCards() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      _errorMessage = 'No user logged in';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _cards = await _repository.getPaymentCards(userId);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _cards = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Stream payment cards (real-time updates)
  Stream<List<PaymentCardModel>> streamPaymentCards() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return Stream.value([]);
    }
    return _repository.streamPaymentCards(userId);
  }

  // Add new payment card
  Future<bool> addPaymentCard({
    required String cardHolderName,
    required String cardNumber,
    required String expiryMonth,
    required String expiryYear,
    required String cvv,
    required String cardType,
  }) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      _errorMessage = 'No user logged in';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final card = PaymentCardModel(
        id: '',
        userId: userId,
        cardHolderName: cardHolderName,
        cardNumber: cardNumber,
        expiryMonth: expiryMonth,
        expiryYear: expiryYear,
        cvv: cvv,
        cardType: cardType,
        createdAt: DateTime.now(),
      );

      await _repository.addPaymentCard(card);
      await loadPaymentCards(); // Reload cards
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Delete payment card
  Future<bool> deletePaymentCard(String cardId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.deletePaymentCard(cardId);
      await loadPaymentCards(); // Reload cards
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
