import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerificationPage extends StatefulWidget {
  final String email;
  final bool isEmailVerified;

  const VerificationPage({
    super.key,
    required this.email,
    required this.isEmailVerified,
  });

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  bool _emailVerified = false;

  @override
  void initState() {
    super.initState();
    _emailVerified = widget.isEmailVerified;
    _listenToEmailVerification(); // Listen for changes in email verification
  }

  void _listenToEmailVerification() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null && user.emailVerified) {
        setState(() {
          _emailVerified = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Email Verification",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              "We have sent an OTP code to your email ${widget.email}. "
              "Enter the OTP code below to verify.",
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
            if (_emailVerified)
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/home');
                },
                child: const Text('Go to Home'),
              ),
            const SizedBox(height: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    // Handle "Didn't receive email?" logic
                  },
                  child: const Text("Didn't receive email?"),
                ),
                const Text(
                  "You can resend the code in 52s",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
