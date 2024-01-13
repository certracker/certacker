import 'dart:io';

import 'package:certracker/auth/save_data_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

  String? frontImageUrl;
  String? backImageUrl;

  bool isLoading = false;

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
                if (_formKey.currentState?.validate() ?? false) {
                  setState(() {
                    isLoading = true;
                  });
                  // Retrieve values from the TextEditingControllers
                  String vaccinationType = vaccineTypeController.text;
                  String vaccinationManufacturer =
                      vaccineManufacturerController.text;
                 String frontImageURL =
                      await SaveDataService.uploadImageToStorage(
                          frontImageUrl!);
                  String backImageURL =
                      await SaveDataService.uploadImageToStorage(
                          backImageUrl!); // Get the actual image URL
                  String vaccineType = vaccineTypeController.text;
                  String vaccineManufacturer =
                      vaccineManufacturerController.text;
                  String vaccineLotNumber = vaccineLotNumberController.text;
                  String vaccineIssueDate = vaccineIssueDateController.text;
                  String vaccineExpiryDate = vaccineExpiryDateController.text;
                  String vaccinePrivateNote = vaccinePrivateNoteController.text;

                  // Call the service function to save vaccination data
                  await VaccinationService.saveVaccinationData(
                    vaccinationType: vaccinationType,
                    vaccinationManufacturer: vaccinationManufacturer,
                    frontImageUrl: frontImageURL,
                    backImageUrl: backImageURL,
                    vaccineType: vaccineType,
                    vaccineManufacturer: vaccineManufacturer,
                    vaccineLotNumber: vaccineLotNumber,
                    vaccineIssueDate: vaccineIssueDate,
                    vaccineExpiryDate: vaccineExpiryDate,
                    vaccinePrivateNote: vaccinePrivateNote,
                  );
                  setState(() {
                    isLoading = false;
                  });

                  // Navigate back to the dashboard
                  Navigator.pop(context);
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
}
