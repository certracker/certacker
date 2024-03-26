// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:certracker/auth/auth_service.dart';
import 'package:certracker/auth/cert_auth/education_service.dart';
import 'package:certracker/components/form/remider_page/certificate_remider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class EducationForm extends StatefulWidget {
  const EducationForm({super.key});

  @override
  State<EducationForm> createState() => _EducationFormState();
}

class _EducationFormState extends State<EducationForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController educationNameController = TextEditingController();

  final TextEditingController educationdegreeController =
      TextEditingController();

  final TextEditingController educationFieldController =
      TextEditingController();

  final TextEditingController educationGraduationController =
      TextEditingController();

  final TextEditingController educationprivateNoteController =
      TextEditingController();

  bool isLoading = false;
  bool isFileSelected = false;
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
            controller: educationNameController,
            decoration: const InputDecoration(
              labelText: " Name of institution*",
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter the Name of institution";
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: educationdegreeController,
            decoration: const InputDecoration(
              labelText: "Degree*",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: educationFieldController,
            decoration: const InputDecoration(
              labelText: "Field of study*",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: educationGraduationController,
            decoration: const InputDecoration(
              labelText: "Graduation Date*",
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
                educationGraduationController.text =
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
              if (selectedFileUrl != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      await showFileSourceDialog();
                    },
                    child: Text('Change File'),
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
            controller: educationprivateNoteController,
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
                   if (isFileSelected) {
                  setState(() {
                    isLoading = true;
                  });
                  // Retrieve values from the TextEditingControllers
                  String educationName = educationNameController.text;
                  String educationDegree = educationdegreeController.text;
                  String educationField = educationFieldController.text;
                  String graduationDate = educationGraduationController.text;
                  String educationPrivateNote =
                      educationprivateNoteController.text;
                  // Call the service function to save education data
                  await EducationService.saveEducationData(
                    name: educationName,
                    degree: educationDegree,
                    field: educationField,
                    graduationDate: graduationDate,
                    privateNote: educationPrivateNote,
                    filePath: selectedFileUrl ?? '',
                  );
                  setState(() {
                    isLoading = false;
                  });

                                      Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SetReminderPage(
                          certificationName: '',
                          certificationExpiryDate: '',
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(
                          'Please select a file.',
                        ),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
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
                        isFileSelected = true;
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
