// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:certracker/auth/save_data_service.dart';
import 'package:certracker/components/nav_bar/nav_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class CertificationForm extends StatefulWidget {
  const CertificationForm({super.key});

  @override
  State<CertificationForm> createState() => _CertificationFormState();
}

class _CertificationFormState extends State<CertificationForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController certificationNameController =
      TextEditingController();

  final TextEditingController certificationNumberController =
      TextEditingController();

  final TextEditingController certificationIssueDateController =
      TextEditingController();

  final TextEditingController certificationExpiryDateController =
      TextEditingController();

  final TextEditingController certificationFirstReminderController =
      TextEditingController();

  final TextEditingController certificationSecondReminderController =
      TextEditingController();

  final TextEditingController certificationFinalReminderController =
      TextEditingController();

  final TextEditingController certificationPrivateNoteController =
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
            controller: certificationNameController,
            decoration: const InputDecoration(
              labelText: "Credential Name",
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter the Credential Name";
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: certificationNumberController,
            decoration: const InputDecoration(
              labelText: "Credential Record Number (Optional)",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: certificationIssueDateController,
            decoration: const InputDecoration(
              labelText: "Issue Date (Optional)",
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
                certificationIssueDateController.text =
                    selectedDate.toLocal().toString().split(' ')[0];
              }
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: certificationExpiryDateController,
            decoration: const InputDecoration(
              labelText: "Expiry Date (Optional)",
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
                certificationExpiryDateController.text =
                    selectedDate.toLocal().toString().split(' ')[0];
              }
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: certificationFirstReminderController,
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
                certificationFirstReminderController.text =
                    selectedDate.toLocal().toString().split(' ')[0];
              }
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: certificationSecondReminderController,
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
                certificationSecondReminderController.text =
                    selectedDate.toLocal().toString().split(' ')[0];
              }
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: certificationFinalReminderController,
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
                certificationFinalReminderController.text =
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
          // Image upload for Back
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
            controller: certificationPrivateNoteController,
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
                  // Assuming you have retrieved the values from the TextEditingController instances
                  String certificationName = certificationNameController.text;
                  String certificationNumber =
                      certificationNumberController.text;
                  String frontImageURL = frontImageUrl != null
                      ? await SaveDataService.uploadImageToStorage(
                          frontImageUrl!)
                      : '';
                  String backImageURL = backImageUrl != null
                      ? await SaveDataService.uploadImageToStorage(
                          backImageUrl!)
                      : '';
                  String certificationIssueDate =
                      certificationIssueDateController.text;
                  String certificationExpiryDate =
                      certificationExpiryDateController.text;
                  String certificationFirstReminder =
                      certificationFirstReminderController.text;
                  String certificationSecondReminder =
                      certificationSecondReminderController.text;
                  String certificationFinalReminder =
                      certificationFinalReminderController.text;
                  String certificationPrivateNote =
                      certificationPrivateNoteController.text;

                  // Call the saveCertificationData method with the gathered data
                  await CertificationService.saveCertificationData(
                    certificationName: certificationName,
                    certificationNumber: certificationNumber,
                    frontImageUrl: frontImageURL,
                    backImageUrl: backImageURL,
                    certificationIssueDate: certificationIssueDate,
                    certificationExpiryDate: certificationExpiryDate,
                    certificationFirstReminder: certificationFirstReminder,
                    certificationSecondReminder: certificationSecondReminder,
                    certificationFinalReminder: certificationFinalReminder,
                    certificationPrivateNote: certificationPrivateNote,
                  );
                  setState(() {
                    isLoading = false;
                  });

                  // Navigate back to the dashboard
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const BottomNavBar()),
                  );
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
