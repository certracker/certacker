import 'package:certracker/components/nav_bar/nav_bar.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();

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
                fontSize: 16,
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
              onTap: () {
                // Logic to add profile picture
              },
              child: CircleAvatar(
                radius: 70,
                backgroundColor: Colors.grey[300],
                child: const Icon(
                  Icons.person,
                  size: 70,
                  color: Colors.grey,
                ),
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
            const SizedBox(height: 20),
            TextFormField(
              controller: _fullNameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Full Name',
                labelStyle: TextStyle(color: Colors.white),
                border: UnderlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _emailController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.white),
                border: UnderlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phoneController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                labelStyle: TextStyle(color: Colors.white),
                border: UnderlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _dobController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Date of Birth',
                labelStyle: TextStyle(color: Colors.white),
                border: UnderlineInputBorder(),
              ),
              keyboardType: TextInputType.datetime,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _stateController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'State',
                labelStyle: TextStyle(color: Colors.white),
                border: UnderlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _cityController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'City',
                labelStyle: TextStyle(color: Colors.white),
                border: UnderlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _zipCodeController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Zip Code',
                labelStyle: TextStyle(color: Colors.white),
                border: UnderlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Action when Finish button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BottomNavBar(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 165, vertical: 10),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('Finish'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
