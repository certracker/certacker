// ignore_for_file: use_build_context_synchronously

import 'package:certracker/components/colors/app_colors.dart';
import 'package:certracker/model/user/user_model.dart';
import 'package:certracker/registration/complete_profile/complete_profile.dart';
import 'package:certracker/registration/login/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _isChecked = false;

  Future<void> _signUp() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      UserModel newUser = UserModel(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        email: userCredential.user!.email!,
        profilePicture: 'https://example.com/default_profile_image.png',
      );

      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(newUser.toJson());

      // Send email verification
      await userCredential.user!.sendEmailVerification();

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => const CompleteProfile()),
      // );
    } catch (e) {
      // Handle signup errors
      print('Error during sign-up: $e');
      // Show a snackbar or other UI to inform the user about the error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 250,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      "assets/images/signup/signup.png"), // Replace with your image path
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: firstNameController,
                    decoration: const InputDecoration(
                      labelText: "First Name",
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: lastNameController,
                    decoration: const InputDecoration(
                      labelText: "Last Name",
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Confirm Password",
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Checkbox(
                        value: _isChecked,
                        onChanged: (value) {
                          setState(() {
                            _isChecked = value!;
                          });
                        },
                      ),
                      const Text('I agree to the terms and conditions'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () async {
                      showDialog(
                        context: context,
                        barrierDismissible:
                            false, // Prevent dismissing the dialog on tap outside
                        builder: (BuildContext context) {
                          return const Center(
                            child:
                                CircularProgressIndicator(), // Show loading indicator
                          );
                        },
                      );

                      try {
                        // Your sign-up logic or any asynchronous operation here (simulated with a delay for demonstration)
                        await _signUp();

                        Navigator.of(context)
                            .pop(); // Dismiss the loading indicator dialog

                        // Navigate to your desired page after the operation
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const CompleteProfile(),
                          ),
                        );
                      } catch (e) {
                        Navigator.of(context)
                            .pop(); // Dismiss the loading indicator dialog on error

                        // Handle the error if necessary
                        print('Error during sign-up: $e');
                        // Show a SnackBar or any other feedback to the user about the error
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Failed to sign up. Please try again.'),
                          ),
                        );
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
                      padding: const EdgeInsets.all(10),
                      child: const Text(
                        'Sign Up',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text('OR'),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextButton.icon(
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => const VerificationPage()),
                      // );
                    },
                    icon: const Icon(Icons.g_translate),
                    label: const Text('Sign Up with Google'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account?"),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      color:
                          Colors.blue, // Change the color to your desired color
                      fontWeight:
                          FontWeight.bold, // Apply different styles if needed
                      // Add other style properties as needed
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
