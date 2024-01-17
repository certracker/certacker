import 'package:flutter/material.dart';

class EditTravelPage extends StatefulWidget {
  final Map<String, dynamic> initialDetails;

  const EditTravelPage({super.key, required this.initialDetails});

  @override
  State<EditTravelPage> createState() => _EditTravelPageState();
}

class _EditTravelPageState extends State<EditTravelPage> {
  late TextEditingController _titleController;
  late TextEditingController _documentNumberController;
  late TextEditingController _travelCountryController;
  late TextEditingController _placeOfIssueController;
  late TextEditingController _issueDateController;
  late TextEditingController _expiryDateController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialDetails['Title']);
    _documentNumberController = TextEditingController(text: widget.initialDetails['documentNumber']);
    _travelCountryController = TextEditingController(text: widget.initialDetails['travelCountry']);
    _placeOfIssueController = TextEditingController(text: widget.initialDetails['placeOfIssue']);
    _issueDateController = TextEditingController(text: widget.initialDetails['issueDate']);
    _expiryDateController = TextEditingController(text: widget.initialDetails['expiryDate']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Travel'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextField('Credential Name', _titleController),
              buildTextField('Document Number', _documentNumberController),
              const SizedBox(height: 16.0),
              buildTextField('Country', _travelCountryController),
              buildTextField('Place of Issue', _placeOfIssueController),
              const SizedBox(height: 16.0),
              buildTextField('Issue Date', _issueDateController),
              buildTextField('Expiry Date', _expiryDateController),
              const SizedBox(height: 16.0),
              // Add Image pickers or editing options here if needed
              ElevatedButton(
                onPressed: () {
                  // Save the edited data to the database
                  // You can use the _titleController.text, _documentNumberController.text, etc. to get the edited values
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
