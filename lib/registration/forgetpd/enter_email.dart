// ignore_for_file: use_build_context_synchronously

import 'package:certracker/auth/auth_service.dart';
import 'package:certracker/components/colors/app_colors.dart';
import 'package:certracker/registration/forgetpd/password_successful.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordEmailScreen extends StatefulWidget {
  ForgotPasswordEmailScreen({super.key});

  @override
  _ForgotPasswordEmailScreenState createState() => _ForgotPasswordEmailScreenState();
}

class _ForgotPasswordEmailScreenState extends State<ForgotPasswordEmailScreen> {
  final AuthenticationService _authService = AuthenticationService();
  TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset("assets/images/forgetpassword/1.jpg"),
              const SizedBox(height: 20),
              const Text(
                "Forgot Password",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text(
                'Enter the email associated with this account',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Enter Email Address',
                  labelStyle: TextStyle(fontSize: 18),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  setState(() {
                    isLoading = true;
                  });

                  String email = emailController.text.trim();

                  try {
                    await _authService.sendPasswordResetEmail(email);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PasswordChanged(),
                      ),
                    );
                  } catch (e) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Text((e as FirebaseAuthException).message.toString()),
                        );
                      },
                    );
                  } finally {
                    setState(() {
                      isLoading = false;
                    });
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        CustomColors.gradientStart,
                        CustomColors.gradientEnd,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(18),
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          "Send Password Reset Email",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
