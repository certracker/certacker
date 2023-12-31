import 'package:flutter/material.dart';

class CertificationDetailPage extends StatelessWidget {
  final String title;
  final String expiration;

  const CertificationDetailPage({super.key, required this.title, required this.expiration});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Certification Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title: $title',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Expiration Date: $expiration',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}
