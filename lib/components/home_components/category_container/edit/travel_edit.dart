import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  late TextEditingController _frontImageController;
  late TextEditingController _backImageController;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.initialDetails['Title']);
    _documentNumberController = TextEditingController(
        text: widget.initialDetails['documentNumber']);
    _travelCountryController = TextEditingController(
        text: widget.initialDetails['travelCountry']);
    _placeOfIssueController =
        TextEditingController(text: widget.initialDetails['placeOfIssue']);
    _issueDateController =
        TextEditingController(text: widget.initialDetails['issueDate']);
    _expiryDateController =
        TextEditingController(text: widget.initialDetails['expiryDate']);
    _frontImageController =
        TextEditingController(text: widget.initialDetails['frontImageUrl']);
    _backImageController =
        TextEditingController(text: widget.initialDetails['backImageUrl']);
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
              buildImagePicker('Front Image', _frontImageController),
              buildImagePicker('Back Image', _backImageController),
              const SizedBox(height: 16.0),
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
