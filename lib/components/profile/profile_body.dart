import 'package:flutter/material.dart';
import 'package:certracker/auth/auth_service.dart';
import 'package:certracker/auth/user_data_service.dart';
import 'package:certracker/components/colors/app_colors.dart';
import 'package:certracker/components/settings_components/edit_profile/edit_profile.dart';

class ProfileBody extends StatefulWidget {
  const ProfileBody({Key? key}) : super(key: key);

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  final UserDataService _userDataService = UserDataService();
  final AuthenticationService _authenticationService = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.zero, 
      child: FutureBuilder(
        future: _userDataService.getUserDetails(
          _authenticationService.getCurrentUserId() ?? '',
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(CustomColors.gradientEnd),
                strokeWidth: 4.0,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final userData = snapshot.data as Map<String, dynamic>? ?? {};
            return Column(
              children: [
                Container(
                  height: 330,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const EditProfile(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit),
                            label: const Text('Edit'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const SizedBox(height: 20),
                          const Text(
                            "Profile",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _buildAvatar(),
                        ],
                      ),
                    ],
                  ),
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
                      _buildDetailRow(
                        'Full Name',
                        '${userData['firstName']} ${userData['lastName']}',
                      ),
                      _buildDetailRow('Email', userData['email'] ?? ''),
                      _buildDetailRow('Phone No', userData['phone'] ?? ''),
                      _buildDetailRow('Date of Birth', userData['dob'] ?? ''),
                      _buildDetailRow('State', userData['state'] ?? ''),
                      _buildDetailRow('City', userData['city'] ?? ''),
                      _buildDetailRow('Zip Code', userData['zipCode'] ?? ''),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildAvatar() {
    String? userId = _authenticationService.getCurrentUserId();

    return Center(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder(
          future: _userDataService.getUserDetails(userId ?? ''),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(CustomColors.gradientEnd),
              );
            } else {
              final userData = snapshot.data as Map<String, dynamic>? ?? {};
              final String profileImageUrl = userData['profilePicture'] ?? '';

              return Stack(
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: profileImageUrl.isNotEmpty
                        ? NetworkImage(profileImageUrl)
                        : null,
                    child: profileImageUrl.isEmpty
                        ? const Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.grey,
                          )
                        : null,
                  ),
                ],
              );
            }
          },
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
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 18,
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
