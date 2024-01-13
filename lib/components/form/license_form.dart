import 'dart:io';

import 'package:certracker/auth/save_data_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class LicenseForm extends StatefulWidget {
  const LicenseForm({super.key});

  @override
  State<LicenseForm> createState() => _LicenseFormState();
}

class _LicenseFormState extends State<LicenseForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController licenseNameController = TextEditingController();

  final TextEditingController licenseNumberController = TextEditingController();

  final TextEditingController licenseIssueDateController =
      TextEditingController();

  final TextEditingController licenseExpiryDateController =
      TextEditingController();

  final TextEditingController licenseFirstReminderController =
      TextEditingController();

  final TextEditingController licenseSecondReminderController =
      TextEditingController();

  final TextEditingController licenseFinalReminderController =
      TextEditingController();

  final TextEditingController licensePrivateNoteController =
      TextEditingController();

  final TextEditingController licenseStateController = TextEditingController();

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
            controller: licenseNameController,
            decoration: const InputDecoration(
              labelText: "License Type*",
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter the License Type";
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: licenseNumberController,
            decoration: const InputDecoration(
              labelText: "License Number*",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: licenseIssueDateController,
            decoration: const InputDecoration(
              labelText: "Issue Date*",
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
                licenseIssueDateController.text =
                    selectedDate.toLocal().toString().split(' ')[0];
              }
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: licenseExpiryDateController,
            decoration: const InputDecoration(
              labelText: "Expiry Date*",
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
                licenseExpiryDateController.text =
                    selectedDate.toLocal().toString().split(' ')[0];
              }
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: licenseStateController,
            decoration: const InputDecoration(
              labelText: "State*",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: licenseFirstReminderController,
            decoration: const InputDecoration(
              labelText: "First Reminder",
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
                licenseFirstReminderController.text =
                    selectedDate.toLocal().toString().split(' ')[0];
              }
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: licenseSecondReminderController,
            decoration: const InputDecoration(
              labelText: "Second Reminder",
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
                licenseSecondReminderController.text =
                    selectedDate.toLocal().toString().split(' ')[0];
              }
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: licenseFinalReminderController,
            decoration: const InputDecoration(
              labelText: "Final Reminder",
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
                licenseFinalReminderController.text =
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
            controller: licensePrivateNoteController,
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
                  // Call the service function to save license data
                  // Retrieve values from the TextEditingControllers
                  String licenseName = licenseNameController.text;
                  String licenseNumber = licenseNumberController.text;
                  String frontImageURL = frontImageUrl != null
                      ? await SaveDataService.uploadImageToStorage(
                          frontImageUrl!)
                      : '';
                  String backImageURL = backImageUrl != null
                      ? await SaveDataService.uploadImageToStorage(
                          backImageUrl!)
                      : '';
                  String licenseIssueDate = licenseIssueDateController.text;
                  String licenseExpiryDate = licenseExpiryDateController.text;
                  String licenseFirstReminder =
                      licenseFirstReminderController.text;
                  String licenseSecondReminder =
                      licenseSecondReminderController.text;
                  String licenseFinalReminder =
                      licenseFinalReminderController.text;
                  String licensePrivateNote = licensePrivateNoteController.text;
                  String licenseState = licenseStateController.text;

                  // Call the service function to save license data
                  await LicenseService.saveLicenseData(
                    licenseName: licenseName,
                    licenseNumber: licenseNumber,
                    frontImageUrl: frontImageURL,
                    backImageUrl: backImageURL,
                    licenseIssueDate: licenseIssueDate,
                    licenseExpiryDate: licenseExpiryDate,
                    licenseFirstReminder: licenseFirstReminder,
                    licenseSecondReminder: licenseSecondReminder,
                    licenseFinalReminder: licenseFinalReminder,
                    licensePrivateNote: licensePrivateNote,
                    licenseState: licenseState,
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
