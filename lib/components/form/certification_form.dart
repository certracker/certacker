import 'dart:io';
import 'package:certracker/auth/auth_service.dart';
import 'package:certracker/auth/cert_auth/cert_service.dart';
import 'package:certracker/components/form/remider_page/certificate_remider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

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

  final TextEditingController certificationPrivateNoteController =
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
                AuthenticationService authService = AuthenticationService();
                authService.getCurrentUserId();
                if (_formKey.currentState?.validate() ?? false) {
                  setState(() {
                    isLoading = true;
                  });
                  // Assuming you have retrieved the values from the TextEditingController instances
                  String certificationName = certificationNameController.text;
                  String certificationNumber =
                      certificationNumberController.text;
                  String certificationIssueDate =
                      certificationIssueDateController.text;
                  String certificationExpiryDate =
                      certificationExpiryDateController.text;
                  String certificationPrivateNote =
                      certificationPrivateNoteController.text;

                  // Call the saveCertificationData method with the gathered data
                  await CertificationService.saveCertificationData(
                    name: certificationName,
                    number: certificationNumber,
                    issueDate: certificationIssueDate,
                    expiryDate: certificationExpiryDate,
                    privateNote: certificationPrivateNote,
                    filePath: selectedFileUrl ?? '', // Pass file path here
                  );
                  setState(() {
                    isLoading = false;
                  });

                  // Navigate back to the dashboard
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SetReminderPage(
                        certificationName: certificationNameController.text,
                        certificationExpiryDate:
                            certificationExpiryDateController.text,
                      ),
                    ),
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
