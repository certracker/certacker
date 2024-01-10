import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get the current user ID
  String? getCurrentUserId() {
    User? user = _auth.currentUser;
    if (user != null) {
      return user.uid; // Return the UID if the user is authenticated
    } else {
      return null; // Return null if no user is signed in
    }
  }
}
