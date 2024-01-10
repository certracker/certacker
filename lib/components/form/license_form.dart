import 'package:certracker/auth/save_data_service.dart';
import 'package:flutter/material.dart';

class LicenseForm extends StatelessWidget {
  final TextEditingController licenseNameController = TextEditingController();
  final TextEditingController licenseNumberController = TextEditingController();
  final TextEditingController licenseIssueDateController =
      TextEditingController();
  final TextEditingController licenseExpiryDateController =
      TextEditingController();
  final TextEditingController licenseFirstReminderController =
      TextEditingController();
  final TextEditingController licenseSecondReminderController =
      TextEditingController();
  final TextEditingController licenseFinalReminderController =
      TextEditingController();
  final TextEditingController licensePrivateNoteController =
      TextEditingController();
  final TextEditingController licenseStateController = TextEditingController();

  LicenseForm({super.key});

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
        TextFormField(
          controller: licenseNameController,
          decoration: const InputDecoration(
            labelText: "License Type*",
            border: OutlineInputBorder(),
          ),
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
        const SizedBox(height: 16),
        TextFormField(
          controller: licenseFirstReminderController,
          decoration: const InputDecoration(
            labelText: "First Reminder",
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
              licenseFirstReminderController.text =
                  selectedDate.toLocal().toString().split(' ')[0];
            }
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: licenseSecondReminderController,
          decoration: const InputDecoration(
            labelText: "Second Reminder",
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
              licenseSecondReminderController.text =
                  selectedDate.toLocal().toString().split(' ')[0];
            }
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: licenseFinalReminderController,
          decoration: const InputDecoration(
            labelText: "Final Reminder",
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
              licenseFinalReminderController.text =
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
        Container(
          width: 400,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Column(
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
        const SizedBox(height: 16),
        const Text(
          "Back",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: 400,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Column(
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
              // Call the service function to save license data
              // Retrieve values from the TextEditingControllers
              String licenseName = licenseNameController.text;
              String licenseNumber = licenseNumberController.text;
              String frontImageUrl = ''; // Get the actual image URL
              String backImageUrl = ''; // Get the actual image URL
              String licenseIssueDate = licenseIssueDateController.text;
              String licenseExpiryDate = licenseExpiryDateController.text;
              String licenseFirstReminder = licenseFirstReminderController.text;
              String licenseSecondReminder =
                  licenseSecondReminderController.text;
              String licenseFinalReminder = licenseFinalReminderController.text;
              String licensePrivateNote = licensePrivateNoteController.text;
              String licenseState = licenseStateController.text;

              // Call the service function to save license data
              await LicenseService.saveLicenseData(
                licenseName: licenseName,
                licenseNumber: licenseNumber,
                frontImageUrl: frontImageUrl,
                backImageUrl: backImageUrl,
                licenseIssueDate: licenseIssueDate,
                licenseExpiryDate: licenseExpiryDate,
                licenseFirstReminder: licenseFirstReminder,
                licenseSecondReminder: licenseSecondReminder,
                licenseFinalReminder: licenseFinalReminder,
                licensePrivateNote: licensePrivateNote,
                licenseState: licenseState,
              );
            },
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
      ],
    );
  }
}
