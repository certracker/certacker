// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:certracker/components/nav_bar/nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late User? _user;
  final ImagePicker _picker = ImagePicker();
  String _imageUrl = '';

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
          _firstNameController.text = userData['firstName'] ?? '';
          _lastNameController.text = userData['lastName'] ?? '';
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
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              );

              try {
                await updateUserData();

                Navigator.of(context).pop();

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => const BottomNavBar()),
                );
              } catch (e) {
                Navigator.of(context).pop();

                print('Error updating user data: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('Failed to update user data. Please try again.'),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF39115B),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Save', style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
          const SizedBox(width: 16),
        ],
        elevation: 0,
        title: const Text("Edit Profile"),
        centerTitle: true,
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
            const SizedBox(height: 50),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(
                      labelText: 'First Name',
                      border: UnderlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
                      border: UnderlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: UnderlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _dobController,
              decoration: InputDecoration(
                labelText: 'Date of Birth',
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
                  icon: const Icon(Icons.calendar_today),
                ),
              ),
              keyboardType: TextInputType.datetime,
              readOnly: true,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _stateController,
              decoration: const InputDecoration(
                labelText: 'State',
                border: UnderlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: 'City',
                border: UnderlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _zipCodeController,
              decoration: const InputDecoration(
                labelText: 'Zip Code',
                border: UnderlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
