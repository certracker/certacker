// import 'package:certracker/auth/auth_page.dart';
// import 'package:certracker/onboard/onboard.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class AppTrack extends StatefulWidget {
//   const AppTrack({Key? key}) : super(key: key);

//   @override
//   State<AppTrack> createState() => _AppTrackState();
// }

// class _AppTrackState extends State<AppTrack> {
//   late bool _isFirstTime;

//   @override
//   void initState() {
//     super.initState();
//     _checkFirstTime();
//   }

//   Future<void> _checkFirstTime() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool? seen = prefs.getBool('seen');

//     setState(() {
//       _isFirstTime = seen == null || !seen;
//       if (_isFirstTime) {
//         prefs.setBool('seen', true);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _isFirstTime ? const OnBoard() : const AuthPage();
//   }
// }
