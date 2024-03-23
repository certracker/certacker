import 'package:flutter/material.dart';
import 'confirm_deletion.dart';

class DeleteAccountPage extends StatelessWidget {
  const DeleteAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete My Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Deleting your cerTracker account will permanently remove all your personal information and credentials associated with your profile. Any subscription you have will automatically be cancelled once you delete this account.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DeleteConfirmationPage(),
                  ),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
                backgroundColor: Colors.transparent,
              ),
              child: const Text('Delete Account'),
            ),
          ],
        ),
      ),
    );
  }
}
