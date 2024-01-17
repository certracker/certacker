import 'package:flutter/material.dart';

class EditVaccinationPage extends StatefulWidget {
  final Map<String, dynamic> initialDetails;

  const EditVaccinationPage({super.key, required this.initialDetails});

  @override
  State<EditVaccinationPage> createState() => _EditVaccinationPageState();
}

class _EditVaccinationPageState extends State<EditVaccinationPage> {
  late TextEditingController _titleController;
  late TextEditingController _manufacturerController;
  late TextEditingController _lotNumberController;
  late TextEditingController _issueDateController;
  late TextEditingController _expiryDateController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialDetails['Title']);
    _manufacturerController = TextEditingController(text: widget.initialDetails['vaccinationManufacturer']);
    _lotNumberController = TextEditingController(text: widget.initialDetails['vaccineLotNumber']);
    _issueDateController = TextEditingController(text: widget.initialDetails['vaccineIssueDate']);
    _expiryDateController = TextEditingController(text: widget.initialDetails['vaccineExpiryDate']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Vaccination'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextField('Credential Name', _titleController),
              buildTextField('Vaccination Manufacturer', _manufacturerController),
              const SizedBox(height: 16.0),
              buildTextField('Lot Number', _lotNumberController),
              buildTextField('Issue Date', _issueDateController),
              buildTextField('Expiry Date', _expiryDateController),
              const SizedBox(height: 16.0),
              // Add Image pickers or editing options here if needed
              ElevatedButton(
                onPressed: () {
                  // Save the edited data to the database
                  // You can use the _titleController.text, _manufacturerController.text, etc. to get the edited values
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
