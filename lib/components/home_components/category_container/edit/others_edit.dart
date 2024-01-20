import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditOthersPage extends StatefulWidget {
  final Map<String, dynamic> initialDetails;
  final String credentialsId; // Add this line

  const EditOthersPage({
    super.key,
    required this.initialDetails,
    required this.credentialsId, // Add this line
  });

  @override
  State<EditOthersPage> createState() => _EditOthersPageState();
}

class _EditOthersPageState extends State<EditOthersPage> {
  late TextEditingController _titleController;
  late TextEditingController _otherNumberController;
  late TextEditingController _firstReminderController;
  late TextEditingController _secondReminderController;
  late TextEditingController _finalReminderController;
  late TextEditingController _issueDateController;
  late TextEditingController _expiryDateController;
  late TextEditingController _frontImageController;
  late TextEditingController _backImageController;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.initialDetails['Title']);
    _otherNumberController =
        TextEditingController(text: widget.initialDetails['otherNumber']);
    _firstReminderController = TextEditingController(
        text: widget.initialDetails['otherFirstReminder']);
    _secondReminderController = TextEditingController(
        text: widget.initialDetails['otherSecondReminder']);
    _finalReminderController = TextEditingController(
        text: widget.initialDetails['otherFinalReminder']);
    _issueDateController =
        TextEditingController(text: widget.initialDetails['otherIssueDate']);
    _expiryDateController =
        TextEditingController(text: widget.initialDetails['otherExpiryDate']);
    _frontImageController =
        TextEditingController(text: widget.initialDetails['frontImageUrl']);
    _backImageController =
        TextEditingController(text: widget.initialDetails['backImageUrl']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Others'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextField('Credential Name', _titleController),
              buildTextField(
                  'Credential Record Number', _otherNumberController),
              const SizedBox(height: 16.0),
              buildTextField('First Reminder', _firstReminderController),
              buildTextField('Second Reminder', _secondReminderController),
              buildTextField('Final Reminder', _finalReminderController),
              const SizedBox(height: 16.0),
              buildTextField('Issue Date', _issueDateController),
              buildTextField('Expiry Date', _expiryDateController),
              const SizedBox(height: 16.0),
              buildImagePicker('Front Image', _frontImageController),
              buildImagePicker('Back Image', _backImageController),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Save the edited data to the database
                  // You can use the _titleController.text, _otherNumberController.text, etc. to get the edited values
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

  Widget buildImagePicker(String labelText, TextEditingController controller) {
    return GestureDetector(
      onTap: () async {
        final XFile? pickedFile =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          setState(() {
            controller.text = pickedFile.path;
          });
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
            style: const TextStyle(
              fontSize: 14.0,
            ),
          ),
          const SizedBox(height: 8.0),
          Container(
            width: 400,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (controller.text.isNotEmpty)
                  Image.file(
                    File(controller.text),
                    width: 400,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                if (_isNetworkUrl(controller.text))
                  Image.network(
                    controller.text,
                    width: 400,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                if (controller.text.isEmpty && !_isNetworkUrl(controller.text))
                  const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt, size: 40),
                        SizedBox(height: 8),
                        Text(
                          "Add image",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Supported formats: JPEG, PNG, JPG",
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }

  bool _isNetworkUrl(String url) {
    return url.startsWith('http://') || url.startsWith('https://');
  }
}
