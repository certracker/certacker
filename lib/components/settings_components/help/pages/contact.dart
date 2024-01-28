import 'package:flutter/material.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Contact Information',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            _buildContactInfo(
              'Email: support@certracker.com',
              Icons.email,
            ),
            _buildContactInfo(
              'Phone: +1 (555) 123-4567',
              Icons.phone,
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Implement your chat functionality here
                  _openChat();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF39115B),
                  padding: const EdgeInsets.all(16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Chat',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20.0),
        const SizedBox(width: 8.0),
        Text(
          text,
          style: const TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }

  void _openChat() {
    // Implement your chat functionality here
    // For example, you can navigate to a chat screen
    // Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));
    // Remember to replace ChatScreen with your actual chat screen class.
  }
}
