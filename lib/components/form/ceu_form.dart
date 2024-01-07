import 'package:flutter/material.dart';

class CEUForm extends StatelessWidget {
  final TextEditingController courseNameController = TextEditingController();
  final TextEditingController providerController = TextEditingController();
  final TextEditingController completionDateController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController privateNoteController = TextEditingController();

  CEUForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: courseNameController,
            decoration: const InputDecoration(
              labelText: 'Course Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: providerController,
            decoration: const InputDecoration(
              labelText: 'Provider',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: privateNoteController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Private Note',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
