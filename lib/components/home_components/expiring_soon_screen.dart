// ExpiringSoonPage.dart
import 'package:flutter/material.dart';

class ExpiringSoonPage extends StatelessWidget {
  const ExpiringSoonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expiring Soon Page'),
      ),
      body: const Center(
        child: Text('This is the Expiring Soon Page'),
      ),
    );
  }
}