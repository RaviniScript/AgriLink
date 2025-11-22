import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agri_link/models/farmer_model.dart';

class FarmerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'users'; // Changed from 'farmers' to 'users'

  // Get all farmers from users collection where role = 'Farmer'
  Future<List<Farmer>> getAllFarmers() async {
    try {
      print('🔍 Fetching all farmers from users collection...');
      
      QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('role', isEqualTo: 'Farmer')
          .get();

      print('👨‍🌾 Found ${snapshot.docs.length} farmers in database');

      final farmers = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        print('📋 Farmer: ${data['firstName'] ?? 'Unknown'} ${data['lastName'] ?? ''}');
        
        return Farmer.fromFirestore({
          'name': '${data['firstName'] ?? ''} ${data['lastName'] ?? ''}'.trim(),
          'email': data['email'] ?? '',
          'phone': data['phoneNumber'] ?? '',
          'location': data['address'] ?? '',
          'address': data['address'] ?? '',
          'profileImageUrl': data['profileImageUrl'] ?? '',
          'rating': 0.0, // Default rating
          'totalProducts': 0,
          'totalSales': 0,
          'isVerified': false,
          'joinedDate': DateTime.now(), // Use current time as fallback
        }, doc.id);
      }).toList();

      // Sort by name
      farmers.sort((a, b) => a.name.compareTo(b.name));
      
      return farmers;
    } catch (e) {
      print('❌ Error fetching farmers: $e');
      return [];
    }
  }

  // Get farmer by ID from users collection
  Future<Farmer?> getFarmerById(String farmerId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(_collection)
          .doc(farmerId)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        
        // Check if user is actually a farmer
        if (data['role'] != 'Farmer') {
          print('⚠️ User $farmerId is not a farmer');
          return null;
        }
        
        return Farmer.fromFirestore({
          'name': '${data['firstName'] ?? ''} ${data['lastName'] ?? ''}'.trim(),
          'email': data['email'] ?? '',
          'phone': data['phoneNumber'] ?? '',
          'location': data['address'] ?? '',
          'address': data['address'] ?? '',
          'profileImageUrl': data['profileImageUrl'] ?? '',
          'rating': 0.0,
          'totalProducts': 0,
          'totalSales': 0,
          'isVerified': false,
          'joinedDate': DateTime.now(),
        }, doc.id);
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
      // Get all farmers from users collection
      QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('role', isEqualTo: 'Farmer')
          .get();

      final allFarmers = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        
        return Farmer.fromFirestore({
          'name': '${data['firstName'] ?? ''} ${data['lastName'] ?? ''}'.trim(),
          'email': data['email'] ?? '',
          'phone': data['phoneNumber'] ?? '',
          'location': data['address'] ?? '',
          'address': data['address'] ?? '',
          'profileImageUrl': data['profileImageUrl'] ?? '',
          'rating': 0.0,
          'totalProducts': 0,
          'totalSales': 0,
          'isVerified': false,
          'joinedDate': DateTime.now(),
        }, doc.id);
      }).toList();

      // Filter farmers by name or location (case-insensitive)
      final searchTerm = query.toLowerCase();
      final results = allFarmers.where((farmer) {
        return farmer.name.toLowerCase().contains(searchTerm) ||
               farmer.location.toLowerCase().contains(searchTerm);
      }).toList();

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
          .where('role', isEqualTo: 'Farmer')
          .get();

      final allFarmers = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        
        // Handle createdAt - could be Timestamp or DateTime
        return Farmer.fromFirestore({
          'name': '${data['firstName'] ?? ''} ${data['lastName'] ?? ''}'.trim(),
          'email': data['email'] ?? '',
          'phone': data['phoneNumber'] ?? '',
          'location': data['address'] ?? '',
          'address': data['address'] ?? '',
          'profileImageUrl': data['profileImageUrl'] ?? '',
          'rating': 0.0,
          'totalProducts': 0,
          'totalSales': 0,
          'isVerified': false,
          'joinedDate': DateTime.now(),
        }, doc.id);
      }).toList();

      // Filter by location
      final searchTerm = location.toLowerCase();
      return allFarmers.where((farmer) {
        return farmer.location.toLowerCase().contains(searchTerm);
      }).toList();
    } catch (e) {
      print('Error searching farmers by location: $e');
      return [];
    }
  }

  // Stream farmers (for real-time updates)
  Stream<List<Farmer>> streamFarmers() {
    return _firestore
        .collection(_collection)
        .where('role', isEqualTo: 'Farmer')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              
              return Farmer.fromFirestore({
                'name': '${data['firstName'] ?? ''} ${data['lastName'] ?? ''}'.trim(),
                'email': data['email'] ?? '',
                'phone': data['phoneNumber'] ?? '',
                'location': data['address'] ?? '',
                'address': data['address'] ?? '',
                'profileImageUrl': data['profileImageUrl'] ?? '',
                'rating': 0.0,
                'totalProducts': 0,
                'totalSales': 0,
                'isVerified': false,
                'joinedDate': DateTime.now(),
              }, doc.id);
            }).toList());
  }
}
