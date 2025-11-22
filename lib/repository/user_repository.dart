import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../services/image_upload_service.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get user data by UID
  Future<UserModel?> getUserById(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromDocument(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user data: $e');
    }
  }

  // Stream user data (real-time updates)
  Stream<UserModel?> streamUserById(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((doc) => doc.exists ? UserModel.fromDocument(doc) : null);
  }

  // Update user profile
  Future<void> updateUserProfile({
    required String uid,
    String? firstName,
    String? lastName,
    String? address,
    String? phoneNumber,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (firstName != null) updateData['firstName'] = firstName;
      if (lastName != null) updateData['lastName'] = lastName;
      if (address != null) updateData['address'] = address;
      if (phoneNumber != null) updateData['phoneNumber'] = phoneNumber;

      await _firestore.collection('users').doc(uid).update(updateData);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  // Upload profile image
  Future<String?> uploadProfileImage(File imageFile, String uid) async {
    try {
      // Upload to imgBB (free image hosting)
      final downloadUrl = await ImageUploadService.uploadImage(imageFile);
      
      if (downloadUrl != null) {
        // Update user document with profile image URL
        await _firestore.collection('users').doc(uid).update({
          'profileImageUrl': downloadUrl,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
      
      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload profile image: $e');
    }
  }

  // Delete profile image (imgBB doesn't support deletion via API in free tier)
  Future<void> deleteProfileImage(String uid, String imageUrl) async {
    try {
      // Just remove the URL from Firestore (imgBB images remain hosted)
      
      // Remove URL from Firestore
      await _firestore.collection('users').doc(uid).update({
        'profileImageUrl': FieldValue.delete(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to delete profile image: $e');
    }
  }

  // Update user role
  Future<void> updateUserRole(String uid, String role) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'role': role,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update role: $e');
    }
  }
}
