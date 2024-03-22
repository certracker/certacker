// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:certracker/auth/auth_service.dart';
import 'package:certracker/auth/cert_auth/cert_service.dart';
import 'package:certracker/components/nav_bar/nav_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

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
  late TextEditingController _privateNoteController;

  bool _isLoading = false;
  String? selectedFileUrl;

  @override
  void initState() {
    super.initState();
    _certificationNameController =
        TextEditingController(text: widget.initialDetails['Title']);
    _certificationNumberController = TextEditingController(
        text: widget.initialDetails['Number']);
    _issueDateController = TextEditingController(
        text: widget.initialDetails['IssueDate']);
    _expiryDateController = TextEditingController(
        text: widget.initialDetails['ExpiryDate']);
    _privateNoteController = TextEditingController(
        text: widget.initialDetails['PrivateNote']);
        selectedFileUrl = widget.initialDetails['frontImageUrl'];
  }

  @override
  void dispose() {
    _certificationNameController.dispose();
    _certificationNumberController.dispose();
    _issueDateController.dispose();
    _expiryDateController.dispose();
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
                        ? getFileWidget(selectedFileUrl!)
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
                      AuthenticationService authService =
                          AuthenticationService();
                      authService.getCurrentUserId();
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
                        String privateNote = _privateNoteController.text;

                        try {
                          // Call the service to update the existing data
                          await CertificationService.updateCertificationData(
                            credentialsId:
                                widget.initialDetails['credentialsId'],
                            userId: AuthenticationService().getCurrentUserId()!,
                            updatedData: {
                              'Title': certificationName,
                              'Number': certificationNumber,
                              'IssueDate': issueDate,
                              'ExpiryDate': expiryDate,
                              'PrivateNote': privateNote,
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