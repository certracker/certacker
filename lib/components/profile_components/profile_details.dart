import 'package:flutter/material.dart';

class ProfileDetails extends StatelessWidget {
  const ProfileDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Profile",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.purple,
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              color: Colors.white,
              onPressed: () {
                // Action when the edit profile button is pressed
                // Add your logic here
              },
            ),
            const SizedBox(width: 10),
          ],
        ),
        body: Container(
          color: Colors.purple, // Purple background for the body
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 25),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.camera_alt),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                    ),
                    onPressed: () {
                      // Action when the camera icon is pressed
                      // Add your logic for image selection here
                    },
                    color: Colors.white,
                    iconSize: 20,
                  ),
                ],
              ),
              const SizedBox(height: 35),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 35),
                        _buildDetailRow('Full Name', 'John Doe'),
                        // _buildDetailRow('Username', 'johndoe123'),
                        _buildDetailRow('Email', 'john@example.com'),
                        _buildDetailRow('Phone No', '+1234567890'),
                        _buildDetailRow('Date of Birth', '01/01/1990'),
                        _buildDetailRow('State', 'California'),
                        _buildDetailRow('City', 'San Francisco'),
                        _buildDetailRow('Zip Code', '12345'),
                        const SizedBox(
                            height: 20), 
                      ],
                    ),
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
