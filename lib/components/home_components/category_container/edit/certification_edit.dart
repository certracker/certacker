import 'package:flutter/material.dart';

class EditCertificationPage extends StatefulWidget {
  final Map<String, dynamic> initialDetails;

  const EditCertificationPage({super.key, required this.initialDetails});

  @override
  State<EditCertificationPage> createState() => _EditCertificationPageState();
}

class _EditCertificationPageState extends State<EditCertificationPage> {
  late TextEditingController _titleController;
  late TextEditingController _certificationNumberController;
  late TextEditingController _firstReminderController;
  late TextEditingController _secondReminderController;
  late TextEditingController _finalReminderController;
  late TextEditingController _issueDateController;
  late TextEditingController _expiryDateController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialDetails['Title']);
    _certificationNumberController = TextEditingController(text: widget.initialDetails['certificationNumber']);
    _firstReminderController = TextEditingController(text: widget.initialDetails['certificationFirstReminder']);
    _secondReminderController = TextEditingController(text: widget.initialDetails['certificationSecondReminder']);
    _finalReminderController = TextEditingController(text: widget.initialDetails['certificationFinalReminder']);
    _issueDateController = TextEditingController(text: widget.initialDetails['certificationIssueDate']);
    _expiryDateController = TextEditingController(text: widget.initialDetails['certificationExpiryDate']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Certification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextField('Credential Name', _titleController),
              buildTextField('Credential Record Number', _certificationNumberController),
              const SizedBox(height: 16.0),
              buildTextField('First Reminder', _firstReminderController),
              buildTextField('Second Reminder', _secondReminderController),
              buildTextField('Final Reminder', _finalReminderController),
              const SizedBox(height: 16.0),
              buildTextField('Issue Date', _issueDateController),
              buildTextField('Expiry Date', _expiryDateController),
              const SizedBox(height: 16.0),
              // Add Image pickers or editing options here if needed
              ElevatedButton(
                onPressed: () {
                  // Save the edited data to the database
                  // You can use the _titleController.text, _certificationNumberController.text, etc. to get the edited values
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
