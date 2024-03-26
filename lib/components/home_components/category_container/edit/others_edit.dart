// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:certracker/auth/auth_service.dart';
import 'package:certracker/auth/cert_auth/others_service.dart';
import 'package:certracker/components/nav_bar/nav_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

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
  late TextEditingController _otherPrivateNoteController;

  bool _isLoading = false;
  String? selectedFileUrl;

  @override
  void initState() {
    super.initState();
    _otherNameController =
        TextEditingController(text: widget.initialDetails['Title']);
    _otherNumberController =
        TextEditingController(text: widget.initialDetails['Number']);
    _otherIssueDateController =
        TextEditingController(text: widget.initialDetails['IssueDate']);
    _otherExpiryDateController =
        TextEditingController(text: widget.initialDetails['ExpiryDate']);
    _otherPrivateNoteController =
        TextEditingController(text: widget.initialDetails['PrivateNote']);
  }

  @override
  void dispose() {
    _otherNameController.dispose();
    _otherNumberController.dispose();
    _otherIssueDateController.dispose();
    _otherExpiryDateController.dispose();
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
                const SizedBox(height: 42),
                const Text(
                  "Upload File",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 16),
                // File upload section
                 Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await showFileSourceDialog();
                      },
                      child: Container(
                        width: 400,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: selectedFileUrl != null
                            ? Stack(
                                children: [
                                  getFileWidget(selectedFileUrl!),
                                  Positioned(
                                    bottom: 8,
                                    right: 8,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        await showFileSourceDialog();
                                      },
                                      child: const Text('Change File'),
                                    ),
                                  ),
                                ],
                              )
                            : const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.file_upload, size: 40),
                                  SizedBox(height: 8),
                                  Text(
                                    "Upload File",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
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
                      AuthenticationService authService =
                          AuthenticationService();
                      authService.getCurrentUserId();
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
                        String otherPrivateNote =
                            _otherPrivateNoteController.text;

                        try {
                          // Call the service to update the existing data
                          await OthersService.updateOthersData(
                            credentialsId:
                                widget.initialDetails['credentialsId'],
                            userId: AuthenticationService().getCurrentUserId()!,
                            updatedData: {
                              'Title': otherName,
                              'Number': otherNumber,
                              'IssueDate': otherIssueDate,
                              'ExpiryDate': otherExpiryDate,
                              'PrivateNote': otherPrivateNote,
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

  Future<void> showFileSourceDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select File Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context); // Close the dialog
                  try {
                    final FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.any,
                    );
                    if (result != null) {
                      final String? filePath = result.files.single.path;
                      if (filePath != null) {
                        pickFileAndSetUrl(filePath);
                      }
                    }
                  } on PlatformException catch (e) {
                    if (kDebugMode) {
                      print("Unsupported operation$e");
                    }
                  }
                },
                child: const Text('Files'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  // For now, we're not handling image picking
                },
                child: const Text('Camera'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> pickFileAndSetUrl(String filePath) async {
    setState(() {
      selectedFileUrl = filePath;
    });
  }
}

// Function to return appropriate widget based on file type
Widget getFileWidget(String filePath) {
  if (filePath.toLowerCase().endsWith('.pdf')) {
    // Display PDF file using PDFViewer widget
    return PDFView(
      filePath: filePath,
    );
  } else {
    // Display image file using Image.file widget
    return Image.file(File(filePath), fit: BoxFit.cover);
  }
}
