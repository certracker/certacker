import 'package:certracker/components/settings_components/help/pages/contact.dart';
import 'package:certracker/components/settings_components/help/pages/faq.dart';
import 'package:certracker/components/settings_components/help/pages/terms.dart';
import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Help Center",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 4,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: _buildSettingsCard(context),
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context) {
    final List<String> settings = [
      "FAQ",
      "Terms and condition",
      "Contact",
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

  Widget _buildSettingsItem(BuildContext context, String text) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            _navigateToSettingsPage(context, text); // Navigate to the respective page
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
                    Icon(_getIconForSetting(text)), // Get respective icon for each setting
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
        if (text != "Contact") const Divider(height: 0), // Add divider for each item except the last one
      ],
    );
  }

  IconData _getIconForSetting(String text) {
    switch (text) {
      case "FAQ":
        return Icons.chat;
      case "Terms and condition":
        return Icons.document_scanner;
      case "Contact":
        return Icons.phone;
      default:
        return Icons.help;
    }
  }

  void _navigateToSettingsPage(BuildContext context, String text) {
    switch (text) {
      case "FAQ":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FaqPage()),
        );
        break;
      case "Terms and condition":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TermsPage()),
        );
        break;
      case "Contact":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ContactPage()),
        );
        break;
      default:
        // Handle other settings
        break;
    }
  }
}
