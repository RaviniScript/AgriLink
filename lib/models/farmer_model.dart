class Farmer {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String location;
  final String address;
  final String profileImageUrl;
  final double rating;
  final int totalProducts;
  final int totalSales;
  final bool isVerified;
  final DateTime joinedDate;

  Farmer({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
    required this.address,
    this.profileImageUrl = '',
    this.rating = 0.0,
    this.totalProducts = 0,
    this.totalSales = 0,
    this.isVerified = false,
    required this.joinedDate,
  });

  // Convert from Firestore document
  factory Farmer.fromFirestore(Map<String, dynamic> data, String docId) {
    // Handle joinedDate - could be DateTime or Timestamp
    DateTime parsedDate = DateTime.now();
    if (data['joinedDate'] != null) {
      if (data['joinedDate'] is DateTime) {
        parsedDate = data['joinedDate'];
      } else {
        try {
          parsedDate = data['joinedDate'].toDate();
        } catch (e) {
          parsedDate = DateTime.now();
        }
      }
    }
    
    return Farmer(
      id: docId,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      location: data['location'] ?? '',
      address: data['address'] ?? '',
      profileImageUrl: data['profileImageUrl'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
      totalProducts: data['totalProducts'] ?? 0,
      totalSales: data['totalSales'] ?? 0,
      isVerified: data['isVerified'] ?? false,
      joinedDate: parsedDate,
    );
  }

  // Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'location': location,
      'address': address,
      'profileImageUrl': profileImageUrl,
      'rating': rating,
      'totalProducts': totalProducts,
      'totalSales': totalSales,
      'isVerified': isVerified,
      'joinedDate': joinedDate,
    };
  }
}
