import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agri_link/models/buyer_model.dart';

class BuyerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'buyers';

  // Create or update buyer profile
  Future<void> saveBuyerProfile(BuyerModel buyer) async {
    try {
      await _firestore.collection(_collection).doc(buyer.id).set(
            buyer.copyWith(updatedAt: DateTime.now()).toFirestore(),
            SetOptions(merge: true),
          );
    } catch (e) {
      print('Error saving buyer profile: $e');
      rethrow;
    }
  }

  // Get buyer profile by ID
  Future<BuyerModel?> getBuyerProfile(String buyerId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(buyerId).get();
      
      if (doc.exists && doc.data() != null) {
        return BuyerModel.fromFirestore(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      print('Error fetching buyer profile: $e');
      return null;
    }
  }

  // Get buyer profile by phone number
  Future<BuyerModel?> getBuyerByPhone(String phone) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('phone', isEqualTo: phone)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return BuyerModel.fromFirestore(
          snapshot.docs.first.data(),
          snapshot.docs.first.id,
        );
      }
      return null;
    } catch (e) {
      print('Error fetching buyer by phone: $e');
      return null;
    }
  }

  // Update buyer profile
  Future<void> updateBuyerProfile(String buyerId, Map<String, dynamic> updates) async {
    try {
      updates['updatedAt'] = FieldValue.serverTimestamp();
      await _firestore.collection(_collection).doc(buyerId).update(updates);
    } catch (e) {
      print('Error updating buyer profile: $e');
      rethrow;
    }
  }

  // Update profile picture
  Future<void> updateProfilePicture(String buyerId, String imageUrl) async {
    try {
      await _firestore.collection(_collection).doc(buyerId).update({
        'profileImageUrl': imageUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating profile picture: $e');
      rethrow;
    }
  }

  // Update default address
  Future<void> updateDefaultAddress({
    required String buyerId,
    required String address,
    required String city,
    required String postalCode,
  }) async {
    try {
      await _firestore.collection(_collection).doc(buyerId).update({
        'defaultAddress': address,
        'city': city,
        'postalCode': postalCode,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating default address: $e');
      rethrow;
    }
  }

  // Stream buyer profile for real-time updates
  Stream<BuyerModel?> streamBuyerProfile(String buyerId) {
    return _firestore
        .collection(_collection)
        .doc(buyerId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return BuyerModel.fromFirestore(snapshot.data()!, snapshot.id);
      }
      return null;
    });
  }

  // Check if buyer profile exists
  Future<bool> buyerExists(String buyerId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(buyerId).get();
      return doc.exists;
    } catch (e) {
      print('Error checking buyer existence: $e');
      return false;
    }
  }

  // Delete buyer profile
  Future<void> deleteBuyerProfile(String buyerId) async {
    try {
      await _firestore.collection(_collection).doc(buyerId).delete();
    } catch (e) {
      print('Error deleting buyer profile: $e');
      rethrow;
    }
  }
}
