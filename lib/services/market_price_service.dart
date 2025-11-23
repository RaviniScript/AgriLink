import 'package:cloud_firestore/cloud_firestore.dart';

class MarketPriceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Normalize crop name to title case (first letter uppercase)
  String _normalizeCropName(String cropName) {
    final trimmed = cropName.trim();
    if (trimmed.isEmpty) return trimmed;
    return trimmed[0].toUpperCase() + trimmed.substring(1).toLowerCase();
  }

  // Get fair price for a specific crop
  Future<double?> getFairPrice(String cropName) async {
    try {
      final normalized = _normalizeCropName(cropName);
      print('🔍 Looking for market price: $normalized');
      
      final doc = await _firestore
          .collection('market_prices')
          .doc(normalized)
          .get();
      
      if (doc.exists) {
        final fairPrice = (doc.data()?['fair_price'] as num?)?.toDouble();
        print('✅ Found fair price: $fairPrice');
        return fairPrice;
      }
      print('❌ No market price found for: $normalized');
      return null;
    } catch (e) {
      print('❌ Error getting fair price: $e');
      return null;
    }
  }

  // Get complete market price data
  Future<Map<String, dynamic>?> getMarketPrice(String cropName) async {
    try {
      final normalized = _normalizeCropName(cropName);
      print('🔍 Fetching market data for: $normalized');
      
      final doc = await _firestore
          .collection('market_prices')
          .doc(normalized)
          .get();
      
      if (doc.exists) {
        print('✅ Market data found for: $normalized');
        return doc.data();
      }
      print('❌ No market data for: $normalized');
      return null;
    } catch (e) {
      print('❌ Error getting market price: $e');
      return null;
    }
  }

  // Check if crop has market price set
  Future<bool> hasFairPrice(String cropName) async {
    try {
      final normalized = _normalizeCropName(cropName);
      final doc = await _firestore
          .collection('market_prices')
          .doc(normalized)
          .get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }
}
