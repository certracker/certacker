import 'package:certracker/auth/save_data_service.dart';
import 'package:flutter/material.dart';

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
          const SizedBox(height: 16),
          TextFormField(
            controller: otherFirstReminderController,
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
                otherFirstReminderController.text =
                    selectedDate.toLocal().toString().split(' ')[0];
              }
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: otherSecondReminderController,
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
                otherSecondReminderController.text =
                    selectedDate.toLocal().toString().split(' ')[0];
              }
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: otherFinalReminderController,
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
                otherFinalReminderController.text =
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
                if (_formKey.currentState?.validate() ?? false) {
                  setState(() {
                    isLoading = true;
                  });
                  // Retrieve values from the TextEditingControllers
                  String othersName = otherNameController.text;
                  String othersDetails =
                      ''; // Get the details from your UI or elsewhere
                  String frontImageUrl = ''; // Get the actual image URL
                  String backImageUrl = ''; // Get the actual image URL
                  String otherNumber = otherNumberController.text;
                  String otherIssueDate = otherIssueDateController.text;
                  String otherExpiryDate = otherExpiryDateController.text;
                  String otherFirstReminder = otherFirstReminderController.text;
                  String otherSecondReminder =
                      otherSecondReminderController.text;
                  String otherFinalReminder = otherFinalReminderController.text;
                  String otherPrivateNote = otherPrivateNoteController.text;

                  // Call the service function to save Others data
                  await OthersService.saveOthersData(
                    othersName: othersName,
                    othersDetails: othersDetails,
                    frontImageUrl: frontImageUrl,
                    backImageUrl: backImageUrl,
                    otherNumber: otherNumber,
                    otherIssueDate: otherIssueDate,
                    otherExpiryDate: otherExpiryDate,
                    otherFirstReminder: otherFirstReminder,
                    otherSecondReminder: otherSecondReminder,
                    otherFinalReminder: otherFinalReminder,
                    otherPrivateNote: otherPrivateNote,
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
