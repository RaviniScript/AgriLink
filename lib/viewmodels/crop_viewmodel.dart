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
      createdAt: DateTime.now(),
    );
    await _repo.createCrop(crop);
  }

  Future<void> deleteCrop(String id) async {
    await _repo.deleteCrop(id);
  }
}
