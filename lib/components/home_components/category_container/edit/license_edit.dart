import 'package:flutter/material.dart';

class EditLicensePage extends StatefulWidget {
  final Map<String, dynamic> initialDetails;

   const EditLicensePage({super.key, required this.initialDetails});

  @override
  State<EditLicensePage> createState() => _EditLicensePageState();
}

class _EditLicensePageState extends State<EditLicensePage> {
  late TextEditingController _titleController;
  late TextEditingController _licenseNumberController;
  late TextEditingController _firstReminderController;
  late TextEditingController _secondReminderController;
  late TextEditingController _finalReminderController;
  late TextEditingController _stateController;
  late TextEditingController _issueDateController;
  late TextEditingController _expiryDateController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialDetails['Title']);
    _licenseNumberController = TextEditingController(text: widget.initialDetails['licenseNumber']);
    _firstReminderController = TextEditingController(text: widget.initialDetails['licenseFirstReminder']);
    _secondReminderController = TextEditingController(text: widget.initialDetails['licenseSecondReminder']);
    _finalReminderController = TextEditingController(text: widget.initialDetails['licenseFinalReminder']);
    _stateController = TextEditingController(text: widget.initialDetails['licenseState']);
    _issueDateController = TextEditingController(text: widget.initialDetails['licenseIssueDate']);
    _expiryDateController = TextEditingController(text: widget.initialDetails['licenseExpiryDate']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit License'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextField('Credential Name', _titleController),
              buildTextField('License Number', _licenseNumberController),
              const SizedBox(height: 16.0),
              buildTextField('First Reminder', _firstReminderController),
              buildTextField('Second Reminder', _secondReminderController),
              buildTextField('Final Reminder', _finalReminderController),
              const SizedBox(height: 16.0),
              buildTextField('State', _stateController),
              buildTextField('Issue Date', _issueDateController),
              buildTextField('Expiry Date', _expiryDateController),
              const SizedBox(height: 16.0),
              // Add Image pickers or editing options here if needed
              ElevatedButton(
                onPressed: () {
                  // Save the edited data to the database
                  // You can use the _titleController.text, _licenseNumberController.text, etc. to get the edited values
                  // Perform the database update logic here
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
            fontSize: 14.0,
          ),
        ),
        const SizedBox(height: 8.0),
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}
