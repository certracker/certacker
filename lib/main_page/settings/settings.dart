// ignore_for_file: use_build_context_synchronously

import 'package:certracker/components/settings_components/about/about_page.dart';
import 'package:certracker/components/settings_components/change_password/change_password_page.dart';
import 'package:certracker/components/settings_components/delete_account/delete_account.dart';
import 'package:certracker/components/settings_components/edit_profile/edit_profile.dart';
import 'package:certracker/components/settings_components/help/help_page.dart';
import 'package:certracker/components/settings_components/log_out/log_out_page.dart';
import 'package:certracker/components/settings_components/notification/Notification_page.dart';
import 'package:certracker/registration/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void signUserOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    // Navigate to the login page after signing out
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: _buildSettingsCard(context),
            ),
            const SizedBox(height: 20),
            _buildLogoutContainer(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context) {
    final List<String> settings = [
      'Profile',
      'Notification',
      'Change Password',
      'Help',
      'About',
      'Delete My Account', // New option added here
    ];

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: settings.length,
          itemBuilder: (context, index) {
            final String text = settings[index];
            return _buildSettingsItem(context, text);
          },
        ),
      ),
    );
  }

  Widget _buildLogoutContainer(BuildContext context) {
    return GestureDetector(
      onTap: () {
        signUserOut(context);
      },
      child: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF6F0A0A),
          borderRadius: BorderRadius.circular(10.0), // Adding border radius
        ),
        child: const Row(
          children: [
            Icon(
              Icons.logout,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Text(
              'Log Out',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem(BuildContext context, String text) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            _navigateToSettingsPage(
                context, text); // Navigate to the respective page
          },
          child: Container(
            height: 70,
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(_getIconForSetting(
                        text)), // Get respective icon for each setting
                    const SizedBox(width: 10),
                    Text(
                      text,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const Icon(Icons.arrow_forward_ios),
              ],
            ),
          ),
        ),
        if (text != 'About' && text != 'Delete My Account')
          const Divider(
              height: 0), // Add divider for each item except the last one
      ],
    );
  }

  IconData _getIconForSetting(String text) {
    switch (text) {
      case 'Profile':
        return Icons.person;
      case 'Notification':
        return Icons.notifications;
      case 'Change Password':
        return Icons.lock;
      case 'Help':
        return Icons.help;
      case 'About':
        return Icons.info;
      default:
        return Icons
            .delete; // Change default to delete icon for "Delete My Account"
    }
  }

  void _navigateToSettingsPage(BuildContext context, String text) {
    switch (text) {
      case 'Profile':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const EditProfile()),
        );
        break;
      case 'Notification':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NotificationPage()),
        );
        break;
      case 'Change Password':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChangePasswordPage()),
        );
        break;
      case 'Help':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HelpPage()),
        );
        break;
      case 'About':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AboutPage()),
        );
        break;
      case 'Delete My Account':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DeleteAccountPage()),
        );
        break;
      case 'Log Out':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LogOutPage()),
        );
        break;
      default:
        // Handle other settings
        break;
    }
  }
}
