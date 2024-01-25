import 'package:certracker/components/nav_bar/nav_bar.dart';
import 'package:certracker/components/notification/notification.dart';
import 'package:certracker/main.dart';
import 'package:certracker/onboard/onboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
@override
  void initState() {
    super.initState();
    Noti.initialize(flutterLocalNotificationsPlugin);
  }

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
              return const OnBoard();
            }
          }),
    );
  }
}
