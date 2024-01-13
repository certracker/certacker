import 'dart:io';

import 'package:certracker/auth/save_data_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TravelForm extends StatefulWidget {
  const TravelForm({Key? key}) : super(key: key);

  @override
  State<TravelForm> createState() => _TravelFormState();
}

class _TravelFormState extends State<TravelForm> {
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController travelCountryController = TextEditingController();
  final TextEditingController travelPlaceOfIssueController =
      TextEditingController();
  final TextEditingController travelDocumentNumberController =
      TextEditingController();
  final TextEditingController travelIssueDateController =
      TextEditingController();
  final TextEditingController travelExpiryDateController =
      TextEditingController();
  final TextEditingController travelPrivateNoteController =
      TextEditingController();

  String? frontImageUrl;
  String? backImageUrl;

  String documentType = 'Passport'; // Default value
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
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
            const Text("Document Type: ", style: TextStyle(fontSize: 16)),
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
       GestureDetector(
            onTap: () async {
              final XFile? pickedFile =
                  await ImagePicker().pickImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                setState(() {
                  frontImageUrl = pickedFile.path;
                });
              }
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
        GestureDetector(
            onTap: () async {
              final XFile? pickedFile =
                  await ImagePicker().pickImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                setState(() {
                  backImageUrl = pickedFile.path;
                });
              }
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
              if (_validateForm()) {
                setState(() {
                  isLoading = true;
                });
                // Retrieve values from the TextEditingControllers
                 String frontImageURL =
                      await SaveDataService.uploadImageToStorage(
                          frontImageUrl!);
                  String backImageURL =
                      await SaveDataService.uploadImageToStorage(
                          backImageUrl!); // Get the actual image URL
                String travelCountry = travelCountryController.text;
                String placeOfIssue = travelPlaceOfIssueController.text;
                String documentNumber = travelDocumentNumberController.text;
                String issueDate = travelIssueDateController.text;
                String expiryDate = travelExpiryDateController.text;
                String travelPrivateNote = travelPrivateNoteController.text;

                // Call the service function to save travel data
                await TravelService.saveTravelData(
                  frontImageUrl: frontImageURL,
                    backImageUrl: backImageURL,
                  travelCountry: travelCountry,
                  placeOfIssue: placeOfIssue,
                  documentNumber: documentNumber,
                  issueDate: issueDate,
                  expiryDate: expiryDate,
                  travelPrivateNote: travelPrivateNote,
                  documentType:
                      documentType, // Include the selected document type
                );
                setState(() {
                  isLoading = false;
                });

                // Navigate back to the dashboard
                Navigator.pop(context);
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
    );
  }

  bool _validateForm() {
    // You can add more validation checks here if needed
    return documentType.isNotEmpty;
  }
}
