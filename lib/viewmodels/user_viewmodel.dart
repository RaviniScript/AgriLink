import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../repository/user_repository.dart';

class UserViewModel extends ChangeNotifier {
  final UserRepository _repository;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserViewModel({UserRepository? repository})
      : _repository = repository ?? UserRepository();

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get currentUserId => _auth.currentUser?.uid;

  // Load current user data
  Future<void> loadCurrentUser() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      _errorMessage = 'No user logged in';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _repository.getUserById(uid);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _currentUser = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Stream current user (real-time updates)
  Stream<UserModel?> streamCurrentUser() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      return Stream.value(null);
    }
    return _repository.streamUserById(uid);
  }

  // Update profile
  Future<bool> updateProfile({
    String? firstName,
    String? lastName,
    String? address,
    String? phoneNumber,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      _errorMessage = 'No user logged in';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.updateUserProfile(
        uid: uid,
        firstName: firstName,
        lastName: lastName,
        address: address,
        phoneNumber: phoneNumber,
      );

      // Reload user data
      await loadCurrentUser();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Upload profile image
  Future<bool> uploadProfileImage(File imageFile) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      _errorMessage = 'No user logged in';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.uploadProfileImage(imageFile, uid);
      await loadCurrentUser();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Delete profile image
  Future<bool> deleteProfileImage() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null || _currentUser?.profileImageUrl == null) {
      _errorMessage = 'No profile image to delete';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.deleteProfileImage(uid, _currentUser!.profileImageUrl!);
      await loadCurrentUser();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
