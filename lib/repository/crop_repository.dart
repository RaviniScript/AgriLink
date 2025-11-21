import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/crop_model.dart';

class CropRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  CollectionReference get _cropsCollection => _firestore.collection('crops');

  Future<String> uploadImage(File file, String ownerId) async {
    final path = 'crops/$ownerId/${DateTime.now().millisecondsSinceEpoch}_${file.path.split(Platform.pathSeparator).last}';
    final ref = _storage.ref().child(path);
    final task = await ref.putFile(file);
    final url = await task.ref.getDownloadURL();
    return url;
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
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => CropModel.fromDocument(d)).toList());
  }
}
