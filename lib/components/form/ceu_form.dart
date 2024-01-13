import 'dart:io';

import 'package:certracker/auth/save_data_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CEUForm extends StatefulWidget {
  const CEUForm({super.key});

  @override
  State<CEUForm> createState() => _CEUFormState();
}

class _CEUFormState extends State<CEUForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController ceuProgramTitleController =
      TextEditingController();

  final TextEditingController ceuProviderNameController =
      TextEditingController();

  final TextEditingController ceuNumberOfContactHourController =
      TextEditingController();

  final TextEditingController ceuCompletionDateController =
      TextEditingController();

  final TextEditingController ceuprivateNoteController =
      TextEditingController();

  String? frontImageUrl;
  String? backImageUrl;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Credential Information",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: ceuProgramTitleController,
            decoration: const InputDecoration(
              labelText: "Program Title",
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter the Program Title";
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: ceuProviderNameController,
            decoration: const InputDecoration(
              labelText: "Provider’s Name",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: ceuNumberOfContactHourController,
            decoration: const InputDecoration(
              labelText: "Number of contact hour",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: ceuCompletionDateController,
            decoration: const InputDecoration(
              labelText: "Completion Date",
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
                ceuCompletionDateController.text =
                    selectedDate.toLocal().toString().split(' ')[0];
              }
            },
          ),
          const SizedBox(height: 42),
          const Text(
            "Upload Photo",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Front",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),
          // Image upload for Front
          GestureDetector(
            onTap: () async {
              final XFile? pickedFile =
                  await ImagePicker().pickImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                setState(() {
                  frontImageUrl = pickedFile.path;
                });
              }
            },
            child: Container(
              width: 400,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: frontImageUrl != null
                  ? Image.file(File(frontImageUrl!), fit: BoxFit.cover)
                  : const Column(
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
          ),
          const SizedBox(height: 16),
          const Text(
            "Back",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () async {
              final XFile? pickedFile =
                  await ImagePicker().pickImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                setState(() {
                  backImageUrl = pickedFile.path;
                });
              }
            },
            child: Container(
              width: 400,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: backImageUrl != null
                  ? Image.file(File(backImageUrl!), fit: BoxFit.cover)
                  : const Column(
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
          ),
          const SizedBox(height: 42),
          const Text(
            "Private Note",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Want to say something about this credential?",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: ceuprivateNoteController,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Type here...',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  setState(() {
                    isLoading = true;
                  });

                  // Retrieve values from the TextEditingControllers
                  String frontImageURL = frontImageUrl != null
                      ? await SaveDataService.uploadImageToStorage(
                          frontImageUrl!)
                      : '';
                  String backImageURL = backImageUrl != null
                      ? await SaveDataService.uploadImageToStorage(
                          backImageUrl!)
                      : '';
                  String ceuProgramTitle = ceuProgramTitleController.text;
                  String ceuProviderName = ceuProviderNameController.text;
                  String ceuNumberOfContactHour =
                      ceuNumberOfContactHourController.text;
                  String ceuCompletionDate = ceuCompletionDateController.text;
                  String ceuPrivateNote = ceuprivateNoteController.text;

                  // Call the service function to save CEU/CME data
                  await CEUCMEService.saveCEUData(
                    frontImageUrl: frontImageURL,
                    backImageUrl: backImageURL,
                    ceuProgramTitle: ceuProgramTitle,
                    ceuProviderName: ceuProviderName,
                    ceuNumberOfContactHour: ceuNumberOfContactHour,
                    ceuCompletionDate: ceuCompletionDate,
                    ceuPrivateNote: ceuPrivateNote,
                  );
                  setState(() {
                    isLoading = false;
                  });

                  // Navigate back to the dashboard
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(
                        'Please fill in the required fields.',
                      ),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: Visibility(
                visible: !isLoading,
                replacement: const CircularProgressIndicator(),
                child: Container(
                  width: 400,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFF39115B),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    "Save Credential",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
