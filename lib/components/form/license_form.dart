import 'package:flutter/material.dart';

class LicenseForm extends StatelessWidget {
  final TextEditingController licenseNameController = TextEditingController();
  final TextEditingController licenseNumberController = TextEditingController();
  final TextEditingController issueDateController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController photoController = TextEditingController();
  final TextEditingController privateNoteController = TextEditingController();

  LicenseForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: licenseNameController,
            decoration: const InputDecoration(
              labelText: 'License Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: licenseNumberController,
            decoration: const InputDecoration(
              labelText: 'License Number',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: issueDateController,
            decoration: const InputDecoration(
              labelText: 'Issue Date',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.calendar_today),
            ),
            readOnly: true,
            onTap: () async {
            },
          ),
        ],
      ),
    );
  }
}
