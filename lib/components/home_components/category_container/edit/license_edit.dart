import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  late TextEditingController _frontImageController;
  late TextEditingController _backImageController;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.initialDetails['Title']);
    _licenseNumberController =
        TextEditingController(text: widget.initialDetails['licenseNumber']);
    _firstReminderController = TextEditingController(
        text: widget.initialDetails['licenseFirstReminder']);
    _secondReminderController = TextEditingController(
        text: widget.initialDetails['licenseSecondReminder']);
    _finalReminderController = TextEditingController(
        text: widget.initialDetails['licenseFinalReminder']);
    _stateController =
        TextEditingController(text: widget.initialDetails['licenseState']);
    _issueDateController =
        TextEditingController(text: widget.initialDetails['licenseIssueDate']);
    _expiryDateController =
        TextEditingController(text: widget.initialDetails['licenseExpiryDate']);
    _frontImageController =
        TextEditingController(text: widget.initialDetails['frontImageUrl']);
    _backImageController =
        TextEditingController(text: widget.initialDetails['backImageUrl']);
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
              buildImagePicker('Front Image', _frontImageController),
              buildImagePicker('Back Image', _backImageController),
              const SizedBox(height: 16.0),
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
