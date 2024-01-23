// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:certracker/components/nav_bar/nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class CompleteProfile extends StatefulWidget {
  const CompleteProfile({super.key});

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late User? _user;
  final ImagePicker _picker = ImagePicker();
  String _imageUrl = ''; // To store the URL of the uploaded image

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    if (_user != null) {
      DocumentSnapshot<Map<String, dynamic>> userData =
          await _firestore.collection('users').doc(_user!.uid).get();
      if (userData.exists) {
        setState(() {
          _phoneController.text = userData['phone'] ?? '';
          _dobController.text = userData['dob'] ?? '';
          _stateController.text = userData['state'] ?? '';
          _cityController.text = userData['city'] ?? '';
          _zipCodeController.text = userData['zipCode'] ?? '';
          _imageUrl = userData['profilePicture'] ?? '';
        });
      }
    }
  }

  Future<void> updateUserData() async {
    if (_user != null) {
      await _firestore.collection('users').doc(_user!.uid).update({
        'phone': _phoneController.text,
        'dob': _dobController.text,
        'state': _stateController.text,
        'city': _cityController.text,
        'zipCode': _zipCodeController.text,
        'profilePicture': _imageUrl,
      });
    }
  }

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      final imageFile = pickedFile.path;
      final imageFileName = pickedFile.path.split('/').last;

      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child(imageFileName);

      await ref.putFile(File(imageFile));

      final imageUrl = await ref.getDownloadURL();
      setState(() {
        _imageUrl = imageUrl;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF591A8F),
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove back arrow
        actions: [
          TextButton(
            onPressed: () {
              // Action when Skip button is pressed
            },
            child: const Text(
              'Skip',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0, // Remove appbar shadow
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                await _getImage(ImageSource.gallery);
              },
              child: CircleAvatar(
                radius: 70,
                backgroundColor: Colors.grey[300],
                backgroundImage:
                    _imageUrl.isEmpty ? null : NetworkImage(_imageUrl),
                child: _imageUrl.isEmpty
                    ? const Icon(
                        Icons.camera_alt,
                        size: 70,
                        color: Colors.grey,
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Complete Profile",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phoneController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                // prefixIcon: Icon(Icons.phone, color: Colors.white),
                labelStyle: TextStyle(color: Colors.white, fontSize: 18),
                border: UnderlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _dobController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Date of Birth',
                labelStyle: const TextStyle(color: Colors.white, fontSize: 18),
                border: const UnderlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null &&
                        pickedDate != _dobController.text) {
                      setState(() {
                        _dobController.text =
                            pickedDate.toString().split(' ')[0];
                      });
                    }
                  },
                  icon: const Icon(Icons.calendar_today, color: Colors.white),
                ),
              ),
              keyboardType: TextInputType.datetime,
              readOnly: true, // Disable manual keyboard input
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _stateController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'State',
                labelStyle: TextStyle(color: Colors.white, fontSize: 18),
                border: UnderlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _cityController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'City',
                labelStyle: TextStyle(color: Colors.white, fontSize: 18),
                border: UnderlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _zipCodeController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Zip Code',
                labelStyle: TextStyle(color: Colors.white, fontSize: 18),
                border: UnderlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
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
                  await updateUserData();

                  Navigator.of(context)
                      .pop(); // Dismiss the loading indicator dialog

                  // Navigate to BottomNavBar or your desired page after updating
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) =>
                            const BottomNavBar()), // Replace with your navigation
                  );
                } catch (e) {
                  Navigator.of(context)
                      .pop(); // Dismiss the loading indicator dialog on error

                  // Handle the error if necessary
                  print('Error updating user data: $e');
                  // Show a SnackBar or any other feedback to the user about the error
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Failed to update user data. Please try again.', style: TextStyle(fontSize: 18)),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                )
                  ),
              child: const Text('Finish', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
