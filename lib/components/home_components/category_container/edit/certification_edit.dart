// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:certracker/auth/auth_service.dart';
import 'package:certracker/auth/save_data_service.dart';
import 'package:certracker/components/nav_bar/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditCertificationPage extends StatefulWidget {
  final Map<String, dynamic> initialDetails;
  final String credentialsId; // Add this line

  const EditCertificationPage({
    super.key,
    required this.initialDetails,
    required this.credentialsId, // Add this line
  });

  @override
  State<EditCertificationPage> createState() => _EditCertificationPageState();
}

class _EditCertificationPageState extends State<EditCertificationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _certificationNameController;
  late TextEditingController _certificationNumberController;
  late TextEditingController _issueDateController;
  late TextEditingController _expiryDateController;
  late TextEditingController _firstReminderController;
  late TextEditingController _secondReminderController;
  late TextEditingController _finalReminderController;
  late TextEditingController _privateNoteController;

  String? frontImageUrl;
  String? backImageUrl;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _certificationNameController =
        TextEditingController(text: widget.initialDetails['Title']);
    _certificationNumberController = TextEditingController(
        text: widget.initialDetails['certificationNumber']);
    _issueDateController = TextEditingController(
        text: widget.initialDetails['certificationIssueDate']);
    _expiryDateController = TextEditingController(
        text: widget.initialDetails['certificationExpiryDate']);
    _firstReminderController = TextEditingController(
        text: widget.initialDetails['certificationFirstReminder']);
    _secondReminderController = TextEditingController(
        text: widget.initialDetails['certificationSecondReminder']);
    _finalReminderController = TextEditingController(
        text: widget.initialDetails['certificationFinalReminder']);
    _privateNoteController = TextEditingController(
        text: widget.initialDetails['certificationPrivateNote']);
    frontImageUrl = widget.initialDetails['frontImageUrl'];
    backImageUrl = widget.initialDetails['backImageUrl'];
  }

  @override
  void dispose() {
    _certificationNameController.dispose();
    _certificationNumberController.dispose();
    _issueDateController.dispose();
    _expiryDateController.dispose();
    _firstReminderController.dispose();
    _secondReminderController.dispose();
    _finalReminderController.dispose();
    _privateNoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Certification'),
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
                  controller: _certificationNameController,
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
                  controller: _certificationNumberController,
                  decoration: const InputDecoration(
                    labelText: "Credential Record Number (Optional)",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _issueDateController,
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
                      _issueDateController.text =
                          selectedDate.toLocal().toString().split(' ')[0];
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _expiryDateController,
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
                      _expiryDateController.text =
                          selectedDate.toLocal().toString().split(' ')[0];
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _firstReminderController,
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
                      _firstReminderController.text =
                          selectedDate.toLocal().toString().split(' ')[0];
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _secondReminderController,
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
                      _secondReminderController.text =
                          selectedDate.toLocal().toString().split(' ')[0];
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _finalReminderController,
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
                      _finalReminderController.text =
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
                // Image upload for Back
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
                  controller: _privateNoteController,
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
                       AuthenticationService authService = AuthenticationService();
                String? userId = authService.getCurrentUserId();
                      if (_formKey.currentState?.validate() ?? false) {
                        setState(() {
                          _isLoading = true;
                        });

                        // Retrieve values from controllers
                        String certificationName =
                            _certificationNameController.text;
                        String certificationNumber =
                            _certificationNumberController.text;
                        String issueDate = _issueDateController.text;
                        String expiryDate = _expiryDateController.text;
                        String firstReminder = _firstReminderController.text;
                        String secondReminder = _secondReminderController.text;
                        String finalReminder = _finalReminderController.text;
                        String privateNote = _privateNoteController.text;
                         String frontImageURL = frontImageUrl != null
                      ? await SaveDataService.uploadImageToStorage(
                          userId!, frontImageUrl!)
                      : '';
                  String backImageURL = backImageUrl != null
                      ? await SaveDataService.uploadImageToStorage(
                          userId!, backImageUrl!)
                      : '';

                        try {
                          // Call the service to update the existing data
                          await CertificationService.updateCertificationData(
                            credentialsId:
                                widget.initialDetails['credentialsId'],
                            userId: AuthenticationService().getCurrentUserId()!,
                            updatedData: {
                              'Title': certificationName,
                              'certificationNumber': certificationNumber,
                              'frontImageUrl': frontImageURL,
                              'backImageUrl': backImageURL,
                              'certificationIssueDate': issueDate,
                              'certificationExpiryDate': expiryDate,
                              'certificationFirstReminder': firstReminder,
                              'certificationSecondReminder': secondReminder,
                              'certificationFinalReminder': finalReminder,
                              'certificationPrivateNote': privateNote,
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
                              content: Text('Error updating certification: $e'),
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
