import 'package:flutter/material.dart';

class CertificationForm extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController recordNumberController = TextEditingController();
  final TextEditingController issueDateController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController firstReminderController = TextEditingController();
  final TextEditingController secondReminderController = TextEditingController();
  final TextEditingController finalReminderController = TextEditingController();
  final TextEditingController frontPhotoController = TextEditingController();
  final TextEditingController backPhotoController = TextEditingController();
  final TextEditingController privateNoteController = TextEditingController();

  CertificationForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Credential Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: recordNumberController,
            decoration: const InputDecoration(
              labelText: 'Credential Record Number (Optional)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: issueDateController,
            decoration: const InputDecoration(
              labelText: 'Issue Date (Optional)',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.calendar_today),
            ),
            readOnly: true,
            onTap: () async {
              final DateTime? selectedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (selectedDate != null) {
                issueDateController.text =
                    selectedDate.toLocal().toString().split(' ')[0];
              }
            },
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
