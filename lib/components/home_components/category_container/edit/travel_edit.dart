// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:certracker/auth/auth_service.dart';
import 'package:certracker/auth/cert_auth/travel_service.dart';
import 'package:certracker/components/nav_bar/nav_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class EditTravelPage extends StatefulWidget {
  final Map<String, dynamic> initialDetails;
  final String credentialsId;

  const EditTravelPage({
    super.key,
    required this.initialDetails,
    required this.credentialsId,
  });

  @override
  State<EditTravelPage> createState() => _EditTravelPageState();
}

class _EditTravelPageState extends State<EditTravelPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController travelCountryController;
  late TextEditingController travelPlaceOfIssueController;
  late TextEditingController travelDocumentNumberController;
  late TextEditingController travelIssueDateController;
  late TextEditingController travelExpiryDateController;
  late TextEditingController travelPrivateNoteController;

  String documentType = 'Passport'; // Default value
  bool isLoading = false;
  String? selectedFileUrl;

  @override
  void initState() {
    super.initState();

    travelCountryController =
        TextEditingController(text: widget.initialDetails['Country'] ?? '');
    travelPlaceOfIssueController = TextEditingController(
        text: widget.initialDetails['placeOfIssue'] ?? '');
    travelDocumentNumberController = TextEditingController(
        text: widget.initialDetails['documentNumber'] ?? '');
    travelIssueDateController =
        TextEditingController(text: widget.initialDetails['issueDate'] ?? '');
    travelExpiryDateController =
        TextEditingController(text: widget.initialDetails['expiryDate'] ?? '');
    travelPrivateNoteController =
        TextEditingController(text: widget.initialDetails['PrivateNote'] ?? '');
    documentType = widget.initialDetails['Title'] ?? 'Passport';
  }

  @override
  void dispose() {
    travelCountryController.dispose();
    travelPlaceOfIssueController.dispose();
    travelDocumentNumberController.dispose();
    travelIssueDateController.dispose();
    travelExpiryDateController.dispose();
    travelPrivateNoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Travel Credential'),
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
                Row(
                  children: [
                    const Text("Document Type: ",
                        style: TextStyle(fontSize: 16)),
                    Radio<String>(
                      value: "Passport",
                      groupValue: documentType,
                      onChanged: (value) {
                        setState(() {
                          documentType = value!;
                        });
                      },
                    ),
                    const Text("Passport",
                        style: TextStyle(
                          fontSize: 11,
                        )),
                    Radio<String>(
                      value: "Driver’s License",
                      groupValue: documentType,
                      onChanged: (value) {
                        setState(() {
                          documentType = value!;
                        });
                      },
                    ),
                    const Text("Driver’s License",
                        style: TextStyle(
                          fontSize: 11,
                        )),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: travelCountryController,
                  decoration: const InputDecoration(
                    labelText: "Country",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: travelPlaceOfIssueController,
                  decoration: const InputDecoration(
                    labelText: "Place of issue",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: travelDocumentNumberController,
                  decoration: InputDecoration(
                    labelText: documentType == 'Passport'
                        ? "Passport Number"
                        : "Driver’s License Number",
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: travelIssueDateController,
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
                      travelIssueDateController.text =
                          selectedDate.toLocal().toString().split(' ')[0];
                    }
                  },
                ),
                const SizedBox(height: 42),
                TextFormField(
                  controller: travelExpiryDateController,
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
                      travelExpiryDateController.text =
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
                  controller: travelPrivateNoteController,
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
                        String travelCountry = travelCountryController.text;
                        String placeOfIssue = travelPlaceOfIssueController.text;
                        String documentNumber =
                            travelDocumentNumberController.text;
                        String issueDate = travelIssueDateController.text;
                        String expiryDate = travelExpiryDateController.text;
                        String travelPrivateNote =
                            travelPrivateNoteController.text;

                        // Call the service function to update travel data
                        await TravelService.updateTravelData(
                          credentialsId: widget.initialDetails['credentialsId'],
                          userId: AuthenticationService().getCurrentUserId()!,
                          updatedData: {
                            'Country': travelCountry,
                            'placeOfIssue': placeOfIssue,
                            'documentNumber': documentNumber,
                            'issueDate': issueDate,
                            'expiryDate': expiryDate,
                            'PrivateNote': travelPrivateNote,
                            'Title': documentType,
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
