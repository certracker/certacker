import 'package:flutter/material.dart';

class LogOutPage extends StatelessWidget {
  const LogOutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Out'),
      ),
      body: const Center(
        child: Text('This is the Log Out page'),
      ),
    );
  }
}
