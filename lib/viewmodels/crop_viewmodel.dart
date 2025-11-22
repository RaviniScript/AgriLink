import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/crop_model.dart';
import '../repository/crop_repository.dart';

class CropViewModel extends ChangeNotifier {
  final CropRepository _repo;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CropViewModel({CropRepository? repository}) : _repo = repository ?? CropRepository();

  Stream<List<CropModel>> streamMyCrops() {
    final user = _auth.currentUser;
    final ownerId = user?.uid ?? 'unknown_owner';
    return _repo.streamCropsByOwner(ownerId);
  }

  Future<void> addCrop({
    required String name,
    required String category,
    required double quantity,
    required double amount,
    required File imageFile,
    required String city,
    String? ownerId,
  }) async {
    final user = _auth.currentUser;
    final resolvedOwnerId = ownerId ?? user?.uid ?? 'demo_farmer';
    final imageUrl = await _repo.uploadImage(imageFile, resolvedOwnerId);
    final crop = CropModel(
      id: '',
      ownerId: resolvedOwnerId,
      name: name,
      category: category,
      quantity: quantity,
      amount: amount,
      imageUrl: imageUrl,
      city: city,
      createdAt: DateTime.now(),
    );
    await _repo.createCrop(crop);
  }

  Future<void> deleteCrop(String id) async {
    await _repo.deleteCrop(id);
  }

  Future<void> updateCrop({
    required String id,
    required String ownerId,
    required String name,
    required String category,
    required double quantity,
    required double amount,
    required String city,
    required String currentImageUrl,
    File? newImageFile,
  }) async {
    String imageUrl = currentImageUrl;
    
    // Upload new image if provided
    if (newImageFile != null) {
      imageUrl = await _repo.uploadImage(newImageFile, ownerId);
    }
    
    final crop = CropModel(
      id: id,
      ownerId: ownerId,
      name: name,
      category: category,
      quantity: quantity,
      amount: amount,
      imageUrl: imageUrl,
      city: city,
      createdAt: DateTime.now(), // This won't be updated in Firestore since we use update()
    );
    
    await _repo.updateCrop(crop);
  }
}
