import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agri_link/models/farmer_model.dart';

class FarmerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'farmers';

  // Get all farmers
  Future<List<Farmer>> getAllFarmers() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .orderBy('rating', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Farmer.fromFirestore(
                doc.data() as Map<String, dynamic>,
                doc.id,
              ))
          .toList();
    } catch (e) {
      print('Error fetching farmers: $e');
      return [];
    }
  }

  // Get farmer by ID
  Future<Farmer?> getFarmerById(String farmerId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(_collection)
          .doc(farmerId)
          .get();

      if (doc.exists) {
        return Farmer.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }
      return null;
    } catch (e) {
      print('Error fetching farmer by ID: $e');
      return null;
    }
  }

  // Search farmers by name or location
  Future<List<Farmer>> searchFarmers(String query) async {
    try {
      // Get all farmers and filter on client side
      // This avoids needing additional Firebase composite indexes
      QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .get();

      final allFarmers = snapshot.docs
          .map((doc) => Farmer.fromFirestore(
                doc.data() as Map<String, dynamic>,
                doc.id,
              ))
          .toList();

      // Filter farmers by name or location (case-insensitive)
      final searchTerm = query.toLowerCase();
      final results = allFarmers.where((farmer) {
        return farmer.name.toLowerCase().contains(searchTerm) ||
               farmer.location.toLowerCase().contains(searchTerm);
      }).toList();

      // Sort by rating
      results.sort((a, b) => b.rating.compareTo(a.rating));
      return results;
    } catch (e) {
      print('Error searching farmers: $e');
      return [];
    }
  }

  // Search farmers by location
  Future<List<Farmer>> searchFarmersByLocation(String location) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('location', isEqualTo: location)
          .get();

      return snapshot.docs
          .map((doc) => Farmer.fromFirestore(
                doc.data() as Map<String, dynamic>,
                doc.id,
              ))
          .toList();
    } catch (e) {
      print('Error searching farmers by location: $e');
      return [];
    }
  }

  // Stream farmers (for real-time updates)
  Stream<List<Farmer>> streamFarmers() {
    return _firestore
        .collection(_collection)
        .orderBy('rating', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Farmer.fromFirestore(
                  doc.data(),
                  doc.id,
                ))
            .toList());
  }
}
