// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:certracker/auth/auth_service.dart';
import 'package:certracker/auth/cert_auth/license_service.dart';
import 'package:certracker/components/nav_bar/nav_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class EditLicensePage extends StatefulWidget {
  final Map<String, dynamic> initialDetails;
  final String credentialsId; // Add this line

  const EditLicensePage({
    super.key,
    required this.initialDetails,
    required this.credentialsId,
  });

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
  late TextEditingController licensePrivateNoteController;

  bool isLoading = false;
  String? selectedFileUrl;

  @override
  void initState() {
    super.initState();

    licenseNameController =
        TextEditingController(text: widget.initialDetails['Title'] ?? '');
    licenseNumberController = TextEditingController(
        text: widget.initialDetails['Number'] ?? '');
    licenseIssueDateController = TextEditingController(
        text: widget.initialDetails['IssueDate'] ?? '');
    licenseExpiryDateController = TextEditingController(
        text: widget.initialDetails['ExpiryDate'] ?? '');
    licenseStateController = TextEditingController(
        text: widget.initialDetails['State'] ?? '');
    licensePrivateNoteController = TextEditingController(
        text: widget.initialDetails['PrivateNote'] ?? '');
  }

  @override
  void dispose() {
    licenseNameController.dispose();
    licenseNumberController.dispose();
    licenseIssueDateController.dispose();
    licenseExpiryDateController.dispose();
    licenseStateController.dispose();
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
                      AuthenticationService authService =
                          AuthenticationService();
                      authService.getCurrentUserId();
                      if (_formKey.currentState?.validate() ?? false) {
                        setState(() {
                          isLoading = true;
                        });
                        // Retrieve values from the TextEditingControllers
                        String licenseName = licenseNameController.text;
                        String licenseNumber = licenseNumberController.text;
                        String licenseIssueDate =
                            licenseIssueDateController.text;
                        String licenseExpiryDate =
                            licenseExpiryDateController.text;
                        String licensePrivateNote =
                            licensePrivateNoteController.text;
                        String licenseState = licenseStateController.text;

                        // Call the service function to update license data
                        await LicenseService.updateLicenseData(
                          credentialsId: widget.initialDetails['credentialsId'],
                          userId: AuthenticationService().getCurrentUserId()!,
                          updatedData: {
                            'Title': licenseName,
                            'Number': licenseNumber,
                            'IssueDate': licenseIssueDate,
                            'ExpiryDate': licenseExpiryDate,
                            'State': licenseState,
                            'PrivateNote': licensePrivateNote,
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
