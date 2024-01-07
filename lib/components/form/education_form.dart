import 'package:flutter/material.dart';

class EducationForm extends StatelessWidget {
  final TextEditingController degreeController = TextEditingController();
  final TextEditingController institutionController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController photoController = TextEditingController();
  final TextEditingController privateNoteController = TextEditingController();

  EducationForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: degreeController,
            decoration: const InputDecoration(
              labelText: 'Degree',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: institutionController,
            decoration: const InputDecoration(
              labelText: 'Institution',
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
