import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/crop_model.dart';
import '../services/image_upload_service.dart';

class CropRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _cropsCollection => _firestore.collection('crops');

  Future<String?> uploadImage(File file, String ownerId) async {
    try {
      // Upload to imgBB (free image hosting)
      final imageUrl = await ImageUploadService.uploadImage(file);
      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<List<String>> uploadMultipleImages(List<File> files, String ownerId) async {
    try {
      List<String> uploadedUrls = [];
      
      for (var file in files) {
        final imageUrl = await ImageUploadService.uploadImage(file);
        if (imageUrl != null) {
          uploadedUrls.add(imageUrl);
        }
      }
      
      return uploadedUrls;
    } catch (e) {
      print('Error uploading multiple images: $e');
      return [];
    }
  }

  Future<void> createCrop(CropModel crop) async {
    await _cropsCollection.add(crop.toJson());
  }

  Future<void> updateCrop(CropModel crop) async {
    await _cropsCollection.doc(crop.id).update(crop.toJson());
  }

  Future<void> deleteCrop(String id) async {
    await _cropsCollection.doc(id).delete();
  }

  Stream<List<CropModel>> streamCropsByOwner(String ownerId) {
    return _cropsCollection
        .where('ownerId', isEqualTo: ownerId)
        .snapshots()
        .map((snap) {
          final crops = snap.docs.map((d) => CropModel.fromDocument(d)).toList();
          // Sort in memory to avoid Firestore index requirement
          crops.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return crops;
        });
  }
}
