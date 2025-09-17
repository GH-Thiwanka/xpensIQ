import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Userservice {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Register user with Firebase
  static Future<bool> storeUserDetails({
    required String userName,
    required String email,
    required String password,
    required String confirmPassword,
    required BuildContext context,
  }) async {
    try {
      // Validate passwords match
      if (password != confirmPassword) {
        _showErrorSnackBar(
          context,
          'Password and Confirm Password do not match',
        );
        return false;
      }

      // Validate password strength
      if (password.length < 6) {
        _showErrorSnackBar(context, 'Password must be at least 6 characters');
        return false;
      }

      // Validate email format
      if (!_isValidEmail(email)) {
        _showErrorSnackBar(context, 'Please enter a valid email address');
        return false;
      }

      // Create user with email and password
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password,
          );

      // Update display name
      await userCredential.user?.updateDisplayName(userName.trim());

      // Store additional user data in Firestore
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'name': userName.trim(),
        'email': email.trim().toLowerCase(),
        'createdAt': FieldValue.serverTimestamp(),
        'uid': userCredential.user?.uid,
      });

      // Store user data in SharedPreferences for quick access
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', userName.trim());
      await prefs.setString('email', email.trim());
      await prefs.setString('uid', userCredential.user?.uid ?? '');

      _showSuccessSnackBar(context, 'Account created successfully!');
      return true;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'The password provided is too weak.';
          break;
        case 'email-already-in-use':
          errorMessage = 'An account already exists for this email.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        default:
          errorMessage = 'Registration failed. Please try again.';
      }
      _showErrorSnackBar(context, errorMessage);
      return false;
    } catch (e) {
      _showErrorSnackBar(context, 'An unexpected error occurred.');
      return false;
    }
  }

  // Sign in user with Firebase
  static Future<bool> signInUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Get user data from Firestore and store in SharedPreferences
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user?.uid)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', userData['name'] ?? '');
        await prefs.setString('email', userData['email'] ?? '');
        await prefs.setString('uid', userCredential.user?.uid ?? '');
      }

      _showSuccessSnackBar(context, 'Welcome back!');
      return true;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for this email.';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password provided.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'user-disabled':
          errorMessage = 'This user account has been disabled.';
          break;
        default:
          errorMessage = 'Login failed. Please check your credentials.';
      }
      _showErrorSnackBar(context, errorMessage);
      return false;
    } catch (e) {
      _showErrorSnackBar(context, 'An unexpected error occurred.');
      return false;
    }
  }

  // Sign out user
  static Future<void> signOut() async {
    await _auth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Get current user
  static User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Check if user is signed in (updated to work with Firebase)
  static Future<bool> checkUserName() async {
    // First check if user is authenticated with Firebase
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      return true;
    }

    // Fallback to SharedPreferences check
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userName = prefs.getString('username');
    return userName != null;
  }

  // Get user data (updated to work with Firebase)
  static Future<Map<String, String>> getUserData() async {
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      // Get from Firebase first
      try {
        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists) {
          Map<String, dynamic> userData =
              userDoc.data() as Map<String, dynamic>;
          return {
            'username': userData['name'] ?? currentUser.displayName ?? '',
            'email': userData['email'] ?? currentUser.email ?? '',
            'uid': currentUser.uid,
          };
        }
      } catch (e) {
        print('Error fetching user data from Firestore: $e');
      }
    }

    // Fallback to SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userName = prefs.getString('username');
    String? email = prefs.getString('email');
    String? uid = prefs.getString('uid');

    return {'username': userName ?? '', 'email': email ?? '', 'uid': uid ?? ''};
  }

  // Get user data from Firestore
  static Future<DocumentSnapshot?> getUserDataFromFirestore(String uid) async {
    try {
      return await _firestore.collection('users').doc(uid).get();
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  // Email validation helper
  static bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Helper methods for showing messages
  static void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
