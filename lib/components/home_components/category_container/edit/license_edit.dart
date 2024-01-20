// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:certracker/auth/auth_service.dart';
import 'package:certracker/auth/save_data_service.dart';
import 'package:certracker/components/nav_bar/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditLicensePage extends StatefulWidget {
  final Map<String, dynamic> initialDetails;

  const EditLicensePage({super.key, required this.initialDetails});

  @override
  State<EditLicensePage> createState() => _EditLicensePageState();
}

class _EditLicensePageState extends State<EditLicensePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController licenseNameController;
  late TextEditingController licenseNumberController;
  late TextEditingController licenseIssueDateController;
  late TextEditingController licenseExpiryDateController;
  late TextEditingController licenseStateController;
  late TextEditingController licenseFirstReminderController;
  late TextEditingController licenseSecondReminderController;
  late TextEditingController licenseFinalReminderController;
  late TextEditingController licensePrivateNoteController;

  String? frontImageUrl;
  String? backImageUrl;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    licenseNameController =
        TextEditingController(text: widget.initialDetails['Title'] ?? '');
    licenseNumberController =
        TextEditingController(text: widget.initialDetails['licenseNumber'] ?? '');
    licenseIssueDateController =
        TextEditingController(text: widget.initialDetails['licenseIssueDate'] ?? '');
    licenseExpiryDateController =
        TextEditingController(text: widget.initialDetails['licenseExpiryDate'] ?? '');
    licenseStateController =
        TextEditingController(text: widget.initialDetails['licenseState'] ?? '');
    licenseFirstReminderController =
        TextEditingController(text: widget.initialDetails['licenseFirstReminder'] ?? '');
    licenseSecondReminderController =
        TextEditingController(text: widget.initialDetails['licenseSecondReminder'] ?? '');
    licenseFinalReminderController =
        TextEditingController(text: widget.initialDetails['licenseFinalReminder'] ?? '');
    licensePrivateNoteController =
        TextEditingController(text: widget.initialDetails['licensePrivateNote'] ?? '');
    frontImageUrl = widget.initialDetails['frontImageUrl'];
    backImageUrl = widget.initialDetails['backImageUrl'];
  }

  @override
  void dispose() {
    licenseNameController.dispose();
    licenseNumberController.dispose();
    licenseIssueDateController.dispose();
    licenseExpiryDateController.dispose();
    licenseStateController.dispose();
    licenseFirstReminderController.dispose();
    licenseSecondReminderController.dispose();
    licenseFinalReminderController.dispose();
    licensePrivateNoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit License'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
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
                    final XFile? pickedFile = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
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
                    final XFile? pickedFile = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
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
                        String licenseIssueDate =
                            licenseIssueDateController.text;
                        String licenseExpiryDate =
                            licenseExpiryDateController.text;
                        String licenseFirstReminder =
                            licenseFirstReminderController.text;
                        String licenseSecondReminder =
                            licenseSecondReminderController.text;
                        String licenseFinalReminder =
                            licenseFinalReminderController.text;
                        String licensePrivateNote =
                            licensePrivateNoteController.text;
                        String licenseState = licenseStateController.text;

                        // Call the service function to update license data
                        await LicenseService.updateLicenseData(
                          credentialsId: widget.initialDetails['credentialsId'],
                          userId: AuthenticationService().getCurrentUserId()!,
                          updatedData: {
                            'frontImageUrl': frontImageURL,
                            'backImageUrl': backImageURL,
                            'Title': licenseName,
                            'licenseNumber': licenseNumber,
                            'licenseIssueDate': licenseIssueDate,
                            'licenseExpiryDate': licenseExpiryDate,
                            'licenseState': licenseState,
                            'licenseFirstReminder': licenseFirstReminder,
                            'licenseSecondReminder': licenseSecondReminder,
                            'licenseFinalReminder': licenseFinalReminder,
                            'licensePrivateNote': licensePrivateNote,
                          },
                        );
                        setState(() {
                          isLoading = false;
                        });

                        // Navigate back to the dashboard
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BottomNavBar()),
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
          ),
        ),
      ),
    );
  }
}
