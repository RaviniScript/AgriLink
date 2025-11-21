import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  // Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign Up with Email & Password
  Future<Map<String, dynamic>> signUpWithEmail({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String address,
  }) async {
    try {
      debugPrint('🔵 Starting sign up process for: $email');
      
      // 1. Create user in Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      String uid = userCredential.user!.uid;
      debugPrint('✅ User created in Auth with UID: $uid');

      // 2. Create user document in Firestore
      final userData = {
        'uid': uid,
        'email': email.trim(),
        'firstName': firstName.trim(),
        'lastName': lastName.trim(),
        'address': address.trim(),
        'role': null, // Will be set during role selection
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };
      
      debugPrint('🔵 Attempting to write to Firestore: $userData');
      
      try {
        await _firestore.collection('users').doc(uid).set(userData);
        debugPrint('✅ User document created successfully in Firestore');
      } catch (firestoreError) {
        debugPrint('❌ Firestore write error: $firestoreError');
        // Continue anyway, we'll try to update it later
      }

      // 3. Update display name
      try {
        await userCredential.user!.updateDisplayName('$firstName $lastName');
        debugPrint('✅ Display name updated');
      } catch (displayNameError) {
        debugPrint('⚠️ Display name update failed: $displayNameError');
      }

      return {
        'success': true,
        'message': 'Account created successfully!',
        'uid': uid,
      };
    } on FirebaseAuthException catch (e) {
      debugPrint('❌ FirebaseAuthException: ${e.code} - ${e.message}');
      String errorMessage;
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'The password is too weak.';
          break;
        case 'email-already-in-use':
          errorMessage = 'An account already exists for this email.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is invalid.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Email/password accounts are not enabled.';
          break;
        default:
          errorMessage = 'Registration failed: ${e.message}';
      }
      return {
        'success': false,
        'message': errorMessage,
      };
    } catch (e) {
      debugPrint('❌ Error during sign up: $e');
      return {
        'success': false,
        'message': 'An unexpected error occurred: $e',
      };
    }
  }

  // Sign In with Email & Password
  Future<Map<String, dynamic>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      debugPrint('🔵 Starting sign in process for: $email');
      
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      String uid = userCredential.user!.uid;
      debugPrint('✅ User authenticated with UID: $uid');

      // Get user data to check role
      debugPrint('🔵 Fetching user data from Firestore...');
      Map<String, dynamic>? userData = await getUserData(uid);

      if (userData == null) {
        debugPrint('⚠️ User data not found in Firestore');
        return {
          'success': false,
          'message': 'User data not found. Please contact support.',
        };
      }

      debugPrint('✅ User data retrieved: role = ${userData['role']}');

      return {
        'success': true,
        'message': 'Sign in successful!',
        'uid': uid,
        'role': userData['role'], // Will be null if not set yet
        'userData': userData,
      };
    } on FirebaseAuthException catch (e) {
      debugPrint('❌ FirebaseAuthException: ${e.code} - ${e.message}');
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No account found with this email.';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is invalid.';
          break;
        case 'user-disabled':
          errorMessage = 'This account has been disabled.';
          break;
        case 'invalid-credential':
          errorMessage = 'Invalid email or password.';
          break;
        default:
          errorMessage = 'Sign in failed: ${e.message}';
      }
      return {
        'success': false,
        'message': errorMessage,
      };
    } catch (e) {
      debugPrint('❌ Error during sign in: $e');
      return {
        'success': false,
        'message': 'An unexpected error occurred: $e',
      };
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Update user role (after role selection)
  Future<Map<String, dynamic>> updateUserRole(String role) async {
    try {
      if (currentUserId == null) {
        return {
          'success': false,
          'message': 'No user is currently signed in.',
        };
      }

      debugPrint('🔵 Updating role for user: $currentUserId to $role');
      
      await _firestore.collection('users').doc(currentUserId).update({
        'role': role,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      debugPrint('✅ Role updated successfully in Firestore');

      return {
        'success': true,
        'message': 'Role updated successfully!',
      };
    } catch (e) {
      debugPrint('❌ Failed to update role: $e');
      return {
        'success': false,
        'message': 'Failed to update role: $e',
      };
    }
  }

  // Get user data
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user data: $e');
    }
  }

  // Check if user has selected a role
  Future<bool> hasUserSelectedRole() async {
    try {
      if (currentUserId == null) return false;
      
      DocumentSnapshot doc = await _firestore.collection('users').doc(currentUserId).get();
      if (doc.exists) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        return data?['role'] != null;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Reset Password
  Future<Map<String, dynamic>> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return {
        'success': true,
        'message': 'Password reset email sent. Please check your inbox.',
      };
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No account found with this email.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is invalid.';
          break;
        default:
          errorMessage = 'Failed to send reset email: ${e.message}';
      }
      return {
        'success': false,
        'message': errorMessage,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred: $e',
      };
    }
  }
}
