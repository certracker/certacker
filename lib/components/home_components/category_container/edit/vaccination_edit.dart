// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:certracker/auth/auth_service.dart';
import 'package:certracker/auth/cert_auth/vaccination_service.dart';
import 'package:certracker/components/nav_bar/nav_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class EditVaccinationPage extends StatefulWidget {
  final Map<String, dynamic> initialDetails;
  final String credentialsId;

  const EditVaccinationPage({
    super.key,
    required this.initialDetails,
    required this.credentialsId,
  });

  @override
  State<EditVaccinationPage> createState() => _EditVaccinationPageState();
}

class _EditVaccinationPageState extends State<EditVaccinationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController vaccineTypeController;
  late TextEditingController vaccineManufacturerController;
  late TextEditingController vaccineLotNumberController;
  late TextEditingController vaccineIssueDateController;
  late TextEditingController vaccineExpiryDateController;
  late TextEditingController vaccinePrivateNoteController;

  bool isLoading = false;
  String? selectedFileUrl;

  @override
  void initState() {
    super.initState();

    vaccineTypeController =
        TextEditingController(text: widget.initialDetails['Title'] ?? '');
    vaccineManufacturerController = TextEditingController(
        text: widget.initialDetails['Manufacturer'] ?? '');
    vaccineLotNumberController = TextEditingController(
        text: widget.initialDetails['LotNumber'] ?? '');
    vaccineIssueDateController = TextEditingController(
        text: widget.initialDetails['IssueDate'] ?? '');
    vaccineExpiryDateController = TextEditingController(
        text: widget.initialDetails['ExpiryDate'] ?? '');
    vaccinePrivateNoteController = TextEditingController(
        text: widget.initialDetails['PrivateNote'] ?? '');
  }

  @override
  void dispose() {
    vaccineTypeController.dispose();
    vaccineManufacturerController.dispose();
    vaccineLotNumberController.dispose();
    vaccineIssueDateController.dispose();
    vaccineExpiryDateController.dispose();
    vaccinePrivateNoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Vaccination Credential'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                const SizedBox(height: 42),
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
                      AuthenticationService authService =
                          AuthenticationService();
                      authService.getCurrentUserId();
                      if (_formKey.currentState?.validate() ?? false) {
                        setState(() {
                          isLoading = true;
                        });
                        // Retrieve values from the TextEditingControllers
                        String vaccinationType = vaccineTypeController.text;
                        String vaccinationManufacturer =
                            vaccineManufacturerController.text;

                        String vaccineLotNumber =
                            vaccineLotNumberController.text;
                        String vaccineIssueDate =
                            vaccineIssueDateController.text;
                        String vaccineExpiryDate =
                            vaccineExpiryDateController.text;
                        String vaccinePrivateNote =
                            vaccinePrivateNoteController.text;

                        // Call the service function to update vaccination data
                        await VaccinationService.updateVaccinationData(
                          credentialsId: widget.initialDetails['credentialsId'],
                          userId: AuthenticationService().getCurrentUserId()!,
                          updatedData: {
                            'Title': vaccinationType,
                            'Manufacturer': vaccinationManufacturer,
                            'LotNumber': vaccineLotNumber,
                            'IssueDate': vaccineIssueDate,
                            'ExpiryDate': vaccineExpiryDate,
                            'PrivateNote': vaccinePrivateNote,
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
