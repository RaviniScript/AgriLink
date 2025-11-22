import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agri_link/models/review_model.dart';

class ReviewService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'reviews';

  // Add a new review
  Future<String> addReview(ReviewModel review) async {
    try {
      DocumentReference docRef = await _firestore.collection(_collectionName).add(review.toFirestore());
      return docRef.id;
    } catch (e) {
      print('Error adding review: $e');
      rethrow;
    }
  }

  // Get a specific review by ID
  Future<ReviewModel?> getReview(String reviewId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection(_collectionName).doc(reviewId).get();
      
      if (doc.exists) {
        return ReviewModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      print('Error getting review: $e');
      return null;
    }
  }

  // Get all reviews for a specific product
  Future<List<ReviewModel>> getProductReviews(String productId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_collectionName)
          .where('productId', isEqualTo: productId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => ReviewModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error getting product reviews: $e');
      return [];
    }
  }

  // Get reviews by a specific buyer
  Future<List<ReviewModel>> getBuyerReviews(String buyerId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_collectionName)
          .where('buyerId', isEqualTo: buyerId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => ReviewModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error getting buyer reviews: $e');
      return [];
    }
  }

  // Check if buyer has already reviewed a specific order
  Future<ReviewModel?> getOrderReview(String orderId, String buyerId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_collectionName)
          .where('orderId', isEqualTo: orderId)
          .where('buyerId', isEqualTo: buyerId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return ReviewModel.fromFirestore(
          querySnapshot.docs.first.data() as Map<String, dynamic>,
          querySnapshot.docs.first.id,
        );
      }
      return null;
    } catch (e) {
      print('Error checking order review: $e');
      return null;
    }
  }

  // Update an existing review
  Future<void> updateReview(String reviewId, Map<String, dynamic> updates) async {
    try {
      updates['updatedAt'] = Timestamp.now();
      await _firestore.collection(_collectionName).doc(reviewId).update(updates);
    } catch (e) {
      print('Error updating review: $e');
      rethrow;
    }
  }

  // Delete a review
  Future<void> deleteReview(String reviewId) async {
    try {
      await _firestore.collection(_collectionName).doc(reviewId).delete();
    } catch (e) {
      print('Error deleting review: $e');
      rethrow;
    }
  }

  // Calculate average rating for a product
  Future<Map<String, dynamic>> getProductRatingStats(String productId) async {
    try {
      List<ReviewModel> reviews = await getProductReviews(productId);
      
      if (reviews.isEmpty) {
        return {
          'averageRating': 0.0,
          'totalReviews': 0,
          'ratingDistribution': {5: 0, 4: 0, 3: 0, 2: 0, 1: 0},
        };
      }

      double totalRating = 0;
      Map<int, int> distribution = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};

      for (var review in reviews) {
        totalRating += review.rating;
        int ratingKey = review.rating.round();
        distribution[ratingKey] = (distribution[ratingKey] ?? 0) + 1;
      }

      return {
        'averageRating': totalRating / reviews.length,
        'totalReviews': reviews.length,
        'ratingDistribution': distribution,
      };
    } catch (e) {
      print('Error calculating rating stats: $e');
      return {
        'averageRating': 0.0,
        'totalReviews': 0,
        'ratingDistribution': {5: 0, 4: 0, 3: 0, 2: 0, 1: 0},
      };
    }
  }

  // Stream product reviews (real-time updates)
  Stream<List<ReviewModel>> streamProductReviews(String productId) {
    return _firestore
        .collection(_collectionName)
        .where('productId', isEqualTo: productId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ReviewModel.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  // Check if a review exists for an order
  Future<bool> hasReviewed(String orderId, String buyerId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_collectionName)
          .where('orderId', isEqualTo: orderId)
          .where('buyerId', isEqualTo: buyerId)
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking if reviewed: $e');
      return false;
    }
  }

  // Get recent reviews (for homepage or featured section)
  Future<List<ReviewModel>> getRecentReviews({int limit = 10}) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_collectionName)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map((doc) => ReviewModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error getting recent reviews: $e');
      return [];
    }
  }
}
