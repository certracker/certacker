import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get the current user ID
  String? getCurrentUserId() {
    User? user = _auth.currentUser;
    if (user != null) {
      return user.uid; 
    } else {
      return null;
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Resend password reset email
  Future<void> resendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Change Password
   Future<bool> changePassword(String newPassword) async {
    try {
      await _auth.currentUser?.updatePassword(newPassword);
      // Additional logic, e.g., mark password as changed in the database if needed
      return true; // Password changed successfully
    } catch (e) {
      // Handle errors, e.g., password change failed
      print('Error changing password: $e');
      return false; // Password change failed
    }
  }
}
