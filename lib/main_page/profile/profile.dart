import 'package:certracker/components/colors/app_colors.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(10.0),
        child: AppBar(
          automaticallyImplyLeading: false,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 250,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    CustomColors.gradientStart,
                    CustomColors.gradientEnd,
                  ],
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                  "Profile",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                    // fontWeight: FontWeight.bold,
                  )
                ),
                  _buildAvatar(),
                ]
              )
            ),
            const SizedBox(height: 20),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const SizedBox(height: 20),
                  _buildDetailRow('Full Name', 'John Doe'),
                  // _buildDetailRow('Username', 'johndoe123'),
                  _buildDetailRow('Email', 'john@example.com'),
                  _buildDetailRow('Phone No', '+1234567890'),
                  _buildDetailRow('Date of Birth', '01/01/1990'),
                  _buildDetailRow('State', 'California'),
                  _buildDetailRow('City', 'San Francisco'),
                  _buildDetailRow('Zip Code', '12345'),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(10), // Padding for the container
        child: Stack(
          children: [
            CircleAvatar(
              radius: 50, // Increase the radius for a larger avatar
              backgroundColor: Colors.grey[300],
              child: const Icon(
                Icons.person,
                size: 60, // Increase the icon size for a larger avatar
                color: Colors.grey,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: IconButton(
                onPressed: () {
                  // Handle camera icon press
                  // Add your logic here for image selection
                },
                icon: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
          const Divider(), // Divider for each detail
        ],
      ),
    );
  }
}