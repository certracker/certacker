// ignore_for_file: use_build_context_synchronously

import 'package:certracker/components/buttons/google_button.dart';
import 'package:certracker/components/colors/app_colors.dart';
import 'package:certracker/components/nav_bar/nav_bar.dart';
import 'package:certracker/registration/forgetpd/enter_email.dart';
import 'package:certracker/registration/signup/signup.dart';
import 'package:certracker/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscured = true;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _togglePasswordVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  void signUserIn() async {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Dialog(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 20),
                  Text("Logining In..."),
                ],
              ),
            ),
          );
        },
      );
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavBar()),
        );
        // e.g., Navigator.push(context, MaterialPageRoute(builder: (context) => NextScreen()));
      } catch (e) {
        // Handle signup errors
        print('Error during Login: $e');
        // Show a snackbar or other UI to inform the user about the error

        Navigator.of(context).pop(); // Dismiss the loading dialog

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Login Error"),
              content: const Text("Failed to Login. Please try again."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              "assets/images/login/login.png",
              width: 350,
              fit: BoxFit.cover,
              alignment: Alignment.topLeft,
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ).add(const EdgeInsets.symmetric(horizontal: 20)),
              child: Form(
                key: _formKey, // Assign the form key to the Form widget
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 140),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(fontSize: 18),
                        border: UnderlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: passwordController,
                          obscureText: _isObscured,
                          decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: const TextStyle(fontSize: 18),
                            border: const UnderlineInputBorder(),
                            suffixIcon: GestureDetector(
                              onTap: _togglePasswordVisibility,
                              child: Icon(
                                _isObscured
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                          style: const TextStyle(fontSize: 18),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgotPasswordEmailScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Forgot Password?",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: signUserIn,
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
                        child: const Text(
                          'Login',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                              child:
                                  Divider(color: Colors.black, thickness: 1)),
                          SizedBox(width: 10),
                          Text('OR', style: TextStyle(fontSize: 16)),
                          SizedBox(width: 10),
                          Expanded(
                              child:
                                  Divider(color: Colors.black, thickness: 1)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    GoogleButton(
                        imagepath: "assets/images/signup/google-icon.png",
                        onTap: () => AuthService().signInWithGoogle(context)),
                    const SizedBox(height: 80),

                    // Footer Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don’t have an account?",
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(width: 5),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpPage()),
                            );
                          },
                          child: const Text(
                            'SignUp',
                            style: TextStyle(color: Colors.blue, fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
