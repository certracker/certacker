import 'package:certracker/components/nav_bar/nav_bar.dart';
import 'package:certracker/registration/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // Check if the user is logged in
            if (snapshot.hasData) {
              return const BottomNavBar();
            }

            // Check if the user is not logged in
            else {
              return const LoginPage();
            }
          }),
    );
  }
}
