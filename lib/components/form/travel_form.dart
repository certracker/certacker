import 'package:flutter/material.dart';

class TravelForm extends StatelessWidget {
  final TextEditingController documentTypeController = TextEditingController();
  final TextEditingController documentNumberController = TextEditingController();
  final TextEditingController issueDateController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController photoController = TextEditingController();
  final TextEditingController privateNoteController = TextEditingController();

  TravelForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: documentTypeController,
            decoration: const InputDecoration(
              labelText: 'Document Type',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: documentNumberController,
            decoration: const InputDecoration(
              labelText: 'Document Number',
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
    );
  }
}
