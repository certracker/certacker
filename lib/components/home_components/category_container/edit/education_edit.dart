import 'package:flutter/material.dart';

class EditEducationPage extends StatefulWidget {
  final Map<String, dynamic> initialDetails;

  const EditEducationPage({super.key, required this.initialDetails});

  @override
  State<EditEducationPage> createState() => _EditEducationPageState();
}

class _EditEducationPageState extends State<EditEducationPage> {
  late TextEditingController _titleController;
  late TextEditingController _degreeController;
  late TextEditingController _fieldController;
  late TextEditingController _graduationDateController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialDetails['Title']);
    _degreeController = TextEditingController(text: widget.initialDetails['educationDegree']);
    _fieldController = TextEditingController(text: widget.initialDetails['educationField']);
    _graduationDateController = TextEditingController(text: widget.initialDetails['graduationDate']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Education'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextField('Credential Name', _titleController),
              buildTextField('Degree', _degreeController),
              const SizedBox(height: 16.0),
              buildTextField('Field', _fieldController),
              buildTextField('Graduation Date', _graduationDateController),
              const SizedBox(height: 16.0),
              // Add Image pickers or editing options here if needed
              ElevatedButton(
                onPressed: () {
                  // Save the edited data to the database
                  // You can use the _titleController.text, _degreeController.text, etc. to get the edited values
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
