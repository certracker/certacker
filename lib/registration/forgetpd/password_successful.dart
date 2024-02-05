import 'package:certracker/components/colors/app_colors.dart';
import 'package:certracker/registration/login/login.dart';
import 'package:flutter/material.dart';
import 'package:certracker/auth/auth_service.dart';

class PasswordChanged extends StatefulWidget {
  const PasswordChanged({super.key});

  @override
  State<PasswordChanged> createState() => _PasswordChangedState();
}

class _PasswordChangedState extends State<PasswordChanged> {
  final AuthenticationService _authService = AuthenticationService();
  bool _passwordChanged = false;

  @override
  void initState() {
    super.initState();
    checkPasswordChanged();
  }

  Future<void> checkPasswordChanged() async {
    // Check if the password has been changed using AuthenticationService
    bool passwordChanged = await _authService.changePassword('new_password');

    // Update the state based on whether the password is changed
    setState(() {
      _passwordChanged = passwordChanged;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset("assets/images/forgetpassword/3.jpg"),
            const SizedBox(height: 20),
            const Text(
              "An email has been sent to your email address.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _passwordChanged
                ? Column(
                    children: [
                      const Text(
                        "Kindly check your email for further instructions.",
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const LoginPage()),
                          );
                        },
                        child: Container(
                          width: 300,
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
                          child: const Text(
                            "Login",
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
                  )
                : const Text(
                    "Password change failed. Please try again later.",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
          ],
        ),
      ),
    );
  }
}
