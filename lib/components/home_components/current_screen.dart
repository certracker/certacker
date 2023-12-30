import 'package:flutter/material.dart';

class CurrentPage extends StatelessWidget {
  const CurrentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Current Document",
          style: TextStyle(
            fontSize: 22,
            // fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 5.0,
        centerTitle: true, // Center the title text
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "You have no current document",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 40),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFF591A8F), // Replace with your desired background color
              ),
              child: TextButton.icon(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                ),
                onPressed: () {
                  // Add functionality to the button
                },
                icon: const Icon(Icons.add), // Replace with your desired icon
                label: const Text(
                  "Upload Doc",
                  style: TextStyle(fontSize: 20, color: Colors.white),

                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
