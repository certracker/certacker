// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:certracker/auth/auth_service.dart';
import 'package:certracker/auth/cert_auth/vaccination_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

import 'remider_page/certificate_remider.dart';

class VaccinationForm extends StatefulWidget {
  const VaccinationForm({super.key});

  @override
  State<VaccinationForm> createState() => _VaccinationFormState();
}

class _VaccinationFormState extends State<VaccinationForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController vaccineTypeController = TextEditingController();

  final TextEditingController vaccineManufacturerController =
      TextEditingController();

  final TextEditingController vaccineLotNumberController =
      TextEditingController();

  final TextEditingController vaccineIssueDateController =
      TextEditingController();

  final TextEditingController vaccineExpiryDateController =
      TextEditingController();

  final TextEditingController vaccinePrivateNoteController =
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
            controller: vaccineTypeController,
            decoration: const InputDecoration(
              labelText: "Type of vaccine",
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter the Type of vaccine";
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: vaccineManufacturerController,
            decoration: const InputDecoration(
              labelText: "Vaccine Manufacturer",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: vaccineLotNumberController,
            decoration: const InputDecoration(
              labelText: "Lot Number",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: vaccineIssueDateController,
            decoration: const InputDecoration(
              labelText: "Issue Date",
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
                vaccineIssueDateController.text =
                    selectedDate.toLocal().toString().split(' ')[0];
              }
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: vaccineExpiryDateController,
            decoration: const InputDecoration(
              labelText: "Expiration Date",
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
                vaccineExpiryDateController.text =
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
            controller: vaccinePrivateNoteController,
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
                    String vaccinationType = vaccineTypeController.text;
                    String vaccinationManufacturer =
                        vaccineManufacturerController.text;

                    String vaccineLotNumber = vaccineLotNumberController.text;
                    String vaccineIssueDate = vaccineIssueDateController.text;
                    String vaccineExpiryDate = vaccineExpiryDateController.text;
                    String vaccinePrivateNote =
                        vaccinePrivateNoteController.text;

                    // Call the service function to save vaccination data
                    await VaccinationService.saveVaccinationData(
                      vaccinationType: vaccinationType,
                      manufacturer: vaccinationManufacturer,
                      lotNumber: vaccineLotNumber,
                      issueDate: vaccineIssueDate,
                      expiryDate: vaccineExpiryDate,
                      privateNote: vaccinePrivateNote,
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
