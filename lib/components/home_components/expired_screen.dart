// ExpiredPage.dart
import 'package:flutter/material.dart';

class ExpiredPage extends StatelessWidget {
  const ExpiredPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expired Page'),
      ),
      body: const Center(
        child: Text('This is the Expired Page'),
      ),
    );
  }
}