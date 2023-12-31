import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About CertTracker",
            style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: const Center(
        child: Text("This is the About page"),
      ),
    );
  }
}
