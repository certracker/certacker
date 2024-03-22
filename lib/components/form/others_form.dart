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

class OthersForm extends StatefulWidget {
  const OthersForm({super.key});

  @override
  State<OthersForm> createState() => _OthersFormState();
}

class _OthersFormState extends State<OthersForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController otherNameController = TextEditingController();

  final TextEditingController otherNumberController = TextEditingController();

  final TextEditingController otherIssueDateController =
      TextEditingController();

  final TextEditingController otherExpiryDateController =
      TextEditingController();

  final TextEditingController otherFirstReminderController =
      TextEditingController();

  final TextEditingController otherSecondReminderController =
      TextEditingController();

  final TextEditingController otherFinalReminderController =
      TextEditingController();

  final TextEditingController otherPrivateNoteController =
      TextEditingController();

  bool isLoading = false;
  String? selectedFileUrl;

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
            controller: otherNameController,
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
            controller: otherNumberController,
            decoration: const InputDecoration(
              labelText: "Credential Record Number (Optional)",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: otherIssueDateController,
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
                otherIssueDateController.text =
                    selectedDate.toLocal().toString().split(' ')[0];
              }
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: otherExpiryDateController,
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
                otherExpiryDateController.text =
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
            controller: otherPrivateNoteController,
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
                authService.getCurrentUserId();
                if (_formKey.currentState?.validate() ?? false) {
                  setState(() {
                    isLoading = true;
                  });
                  String othersName = otherNameController.text;
                  String otherNumber = otherNumberController.text;
                  String otherIssueDate = otherIssueDateController.text;
                  String otherExpiryDate = otherExpiryDateController.text;
                  String otherPrivateNote = otherPrivateNoteController.text;

                  // Call the service function to save Others data
                  await OthersService.saveOthersData(
                    name: othersName,
                    // othersDetails: othersDetails,
                    number: otherNumber,
                    issueDate: otherIssueDate,
                    expiryDate: otherExpiryDate,
                    privateNote: otherPrivateNote,
                    filePath: selectedFileUrl ?? '',
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
