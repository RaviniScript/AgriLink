import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agri_link/models/favorites_model.dart';

class FavoritesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'favorites';

  // Add product to favorites
  Future<String> addToFavorites(String buyerId, String productId) async {
    try {
      // Check if already exists
      final existing = await _firestore
          .collection(_collection)
          .where('buyerId', isEqualTo: buyerId)
          .where('productId', isEqualTo: productId)
          .limit(1)
          .get();

      if (existing.docs.isNotEmpty) {
        return existing.docs.first.id;
      }

      // Add new favorite
      final favorite = FavoritesModel(
        id: '',
        buyerId: buyerId,
        productId: productId,
        addedAt: DateTime.now(),
      );

      final docRef =
          await _firestore.collection(_collection).add(favorite.toFirestore());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add to favorites: $e');
    }
  }

  // Remove product from favorites
  Future<void> removeFromFavorites(String buyerId, String productId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('buyerId', isEqualTo: buyerId)
          .where('productId', isEqualTo: productId)
          .limit(1)
          .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw Exception('Failed to remove from favorites: $e');
    }
  }

  // Toggle favorite status
  Future<bool> toggleFavorite(String buyerId, String productId) async {
    try {
      final isFavorited = await isFavorite(buyerId, productId);
      if (isFavorited) {
        await removeFromFavorites(buyerId, productId);
        return false;
      } else {
        await addToFavorites(buyerId, productId);
        return true;
      }
    } catch (e) {
      throw Exception('Failed to toggle favorite: $e');
    }
  }

  // Check if product is in favorites
  Future<bool> isFavorite(String buyerId, String productId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('buyerId', isEqualTo: buyerId)
          .where('productId', isEqualTo: productId)
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      throw Exception('Failed to check favorite status: $e');
    }
  }

  // Get all favorites for a buyer
  Future<List<FavoritesModel>> getBuyerFavorites(String buyerId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('buyerId', isEqualTo: buyerId)
          .orderBy('addedAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => FavoritesModel.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to get favorites: $e');
    }
  }

  // Get favorite by ID
  Future<FavoritesModel?> getFavorite(String favoriteId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(favoriteId).get();

      if (!doc.exists) {
        return null;
      }

      return FavoritesModel.fromFirestore(doc.data()!, doc.id);
    } catch (e) {
      throw Exception('Failed to get favorite: $e');
    }
  }

  // Get favorites count for a buyer
  Future<int> getFavoritesCount(String buyerId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('buyerId', isEqualTo: buyerId)
          .get();

      return querySnapshot.docs.length;
    } catch (e) {
      throw Exception('Failed to get favorites count: $e');
    }
  }

  // Stream buyer favorites (real-time updates)
  Stream<List<FavoritesModel>> streamBuyerFavorites(String buyerId) {
    return _firestore
        .collection(_collection)
        .where('buyerId', isEqualTo: buyerId)
        .orderBy('addedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FavoritesModel.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  // Get favorite product IDs for a buyer (useful for checking multiple products)
  Future<Set<String>> getFavoriteProductIds(String buyerId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('buyerId', isEqualTo: buyerId)
          .get();

      return querySnapshot.docs
          .map((doc) => doc.data()['productId'] as String)
          .toSet();
    } catch (e) {
      throw Exception('Failed to get favorite product IDs: $e');
    }
  }

  // Clear all favorites for a buyer
  Future<void> clearAllFavorites(String buyerId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('buyerId', isEqualTo: buyerId)
          .get();

      final batch = _firestore.batch();
      for (var doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to clear favorites: $e');
    }
  }
}
