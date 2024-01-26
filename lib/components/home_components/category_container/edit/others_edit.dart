// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:certracker/auth/auth_service.dart';
import 'package:certracker/auth/save_data_service.dart';
import 'package:certracker/components/nav_bar/nav_bar.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _otherNameController;
  late TextEditingController _otherNumberController;
  late TextEditingController _otherIssueDateController;
  late TextEditingController _otherExpiryDateController;
  late TextEditingController _otherFirstReminderController;
  late TextEditingController _otherSecondReminderController;
  late TextEditingController _otherFinalReminderController;
  late TextEditingController _otherPrivateNoteController;

  String? frontImageUrl;
  String? backImageUrl;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _otherNameController =
        TextEditingController(text: widget.initialDetails['Title']);
    _otherNumberController =
        TextEditingController(text: widget.initialDetails['otherNumber']);
    _otherIssueDateController = TextEditingController(
        text: widget.initialDetails['otherIssueDate']);
    _otherExpiryDateController = TextEditingController(
        text: widget.initialDetails['otherExpiryDate']);
    _otherFirstReminderController = TextEditingController(
        text: widget.initialDetails['otherFirstReminder']);
    _otherSecondReminderController = TextEditingController(
        text: widget.initialDetails['otherSecondReminder']);
    _otherFinalReminderController = TextEditingController(
        text: widget.initialDetails['otherFinalReminder']);
    _otherPrivateNoteController = TextEditingController(
        text: widget.initialDetails['otherPrivateNote']);
    frontImageUrl = widget.initialDetails['frontImageUrl'];
    backImageUrl = widget.initialDetails['backImageUrl'];
  }

  @override
  void dispose() {
    _otherNameController.dispose();
    _otherNumberController.dispose();
    _otherIssueDateController.dispose();
    _otherExpiryDateController.dispose();
    _otherFirstReminderController.dispose();
    _otherSecondReminderController.dispose();
    _otherFinalReminderController.dispose();
    _otherPrivateNoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Others Credential'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
                  controller: _otherNameController,
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
                  controller: _otherNumberController,
                  decoration: const InputDecoration(
                    labelText: "Credential Record Number (Optional)",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _otherIssueDateController,
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
                      _otherIssueDateController.text =
                          selectedDate.toLocal().toString().split(' ')[0];
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _otherExpiryDateController,
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
                      _otherExpiryDateController.text =
                          selectedDate.toLocal().toString().split(' ')[0];
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _otherFirstReminderController,
                  decoration: const InputDecoration(
                    labelText: "First Reminder (Optional)",
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
                      _otherFirstReminderController.text =
                          selectedDate.toLocal().toString().split(' ')[0];
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _otherSecondReminderController,
                  decoration: const InputDecoration(
                    labelText: "Second Reminder (Optional)",
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
                      _otherSecondReminderController.text =
                          selectedDate.toLocal().toString().split(' ')[0];
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _otherFinalReminderController,
                  decoration: const InputDecoration(
                    labelText: "Final Reminder (Optional)",
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
                      _otherFinalReminderController.text =
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
                GestureDetector(
                  onTap: () async {
                    await pickImageAndSetUrl('front');
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
                    await pickImageAndSetUrl('back');
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
                  controller: _otherPrivateNoteController,
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
                          _isLoading = true;
                        });

                        // Retrieve values from controllers
                        String otherName = _otherNameController.text;
                        String otherNumber = _otherNumberController.text;
                        String otherIssueDate = _otherIssueDateController.text;
                        String otherExpiryDate =
                            _otherExpiryDateController.text;
                        String otherFirstReminder =
                            _otherFirstReminderController.text;
                        String otherSecondReminder =
                            _otherSecondReminderController.text;
                        String otherFinalReminder =
                            _otherFinalReminderController.text;
                        String otherPrivateNote =
                            _otherPrivateNoteController.text;
                        String frontImageURL = frontImageUrl != null
                            ? await SaveDataService.uploadImageToStorage(
                                frontImageUrl!)
                            : '';
                        String backImageURL = backImageUrl != null
                            ? await SaveDataService.uploadImageToStorage(
                                backImageUrl!)
                            : '';

                        try {
                          // Call the service to update the existing data
                          await OthersService.updateOthersData(
                            credentialsId:
                                widget.initialDetails['credentialsId'],
                            userId: AuthenticationService().getCurrentUserId()!,
                            updatedData: {
                              'Title': otherName,
                              'frontImageUrl': frontImageURL,
                              'backImageUrl': backImageURL,
                              'otherNumber': otherNumber,
                              'otherIssueDate': otherIssueDate,
                              'otherExpiryDate': otherExpiryDate,
                              'otherFirstReminder': otherFirstReminder,
                              'otherSecondReminder': otherSecondReminder,
                              'otherFinalReminder': otherFinalReminder,
                              'otherPrivateNote': otherPrivateNote,
                            },
                          );

                          setState(() {
                            _isLoading = false;
                          });

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const BottomNavBar()),
                          ); // Navigate back
                        } catch (e) {
                          setState(() {
                            _isLoading = false;
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              content:
                                  Text('Error updating others credential: $e'),
                              duration: const Duration(seconds: 10),
                            ),
                          );
                        }
                      }
                    },
                    child: Visibility(
                      visible: !_isLoading,
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

  Future<void> pickImageAndSetUrl(String type) async {
    final XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (type == 'front') {
          frontImageUrl = pickedFile.path;
        } else {
          backImageUrl = pickedFile.path;
        }
      });
    }
  }
}
