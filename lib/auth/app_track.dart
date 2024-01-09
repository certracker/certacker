import 'package:certracker/auth/auth_page.dart';
import 'package:certracker/onboarding/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppTrack extends StatelessWidget {
  const AppTrack({super.key});

  Future<bool> _checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? seen = prefs.getBool('seen');

    if (seen == null || !seen) {
      await prefs.setBool('seen', true);
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkFirstSeen(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasData) {
          if (snapshot.data!) {
            return const OnboardingScreens();
          } else {
            return const AuthPage();
          }
        } else {
          return const Scaffold(
            body: Center(
              child: Text('Error occurred!'),
            ),
          );
        }
      },
    );
  }
}
