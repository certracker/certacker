import 'package:flutter/material.dart';

class LicenseDetailPage extends StatelessWidget {
  final String title;
  final String expiration;

  const LicenseDetailPage(
      {super.key, required this.title, required this.expiration});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Expanded(
              child: Text(
                'License Details',
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              onPressed: () {
                // Add your edit functionality here
              },
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () {
                // Add your share functionality here
              },
              icon: const Icon(Icons.share),
            ),
          ],
        ),
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
