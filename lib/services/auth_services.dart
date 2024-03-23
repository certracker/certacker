// ignore_for_file: use_build_context_synchronously

import 'package:certracker/auth/auth_page.dart';
import 'package:certracker/auth/user_data_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'; // Import the material package
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  final UserDataService _userDataService = UserDataService(); // Initialize UserDataService

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      // Show loading indicator while signing up
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      Navigator.pop(context); // Close loading indicator

      if (googleUser == null) {
        // User canceled the sign-in process
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      // Check if the user is newly created (sign-up) and update the database
      if (userCredential.additionalUserInfo?.isNewUser == true) {
        final User? user = userCredential.user;

        // Log the displayName to the console
        if (kDebugMode) {
          print('User displayName: ${user?.displayName}');
        }

        // Extract first name and last name from displayName
        final displayNameParts = user?.displayName?.split(' ') ?? [];
        final firstName = displayNameParts.isNotEmpty ? displayNameParts[0] : '';
        final lastName = displayNameParts.length > 1 ? displayNameParts[1] : '';

        // Additional user details to be stored in the database
        final userDetails = {
          'firstName': firstName,
          'lastName': lastName,
          'email': user?.email,
          // Add more details as needed
        };

        await _userDataService.addUserDetails(user?.uid ?? '', userDetails);
      }

      // Reload the page by pushing the same route
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AuthPage()));

    } catch (error) {
      print("Error signing in with Google: $error");
      Navigator.pop(context); // Close loading indicator if an error occurs
    }
  }

  
}
