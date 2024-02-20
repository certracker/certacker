// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:certracker/auth/auth_service.dart';
import 'package:certracker/components/form/remider_page/certificate_remider.dart';

import 'package:timezone/timezone.dart' as tz;

import 'package:certracker/auth/save_data_service.dart';
// import 'package:certracker/components/nav_bar/nav_bar.dart';
import 'package:certracker/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

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

  // final TextEditingController certificationFirstReminderController =
  //     TextEditingController();

  // final TextEditingController certificationSecondReminderController =
  //     TextEditingController();

  // final TextEditingController certificationFinalReminderController =
  //     TextEditingController();

  final TextEditingController certificationPrivateNoteController =
      TextEditingController();

  String? frontImageUrl;
  String? backImageUrl;

  bool isLoading = false;

  Future<void> scheduleNotification(
      String reminderType, DateTime selectedDate) async {
    String reminderMessage = '';
    switch (reminderType) {
      case 'First Reminder':
        reminderMessage = 'First Reminder: Time to be reminded!';
        break;
      case 'Second Reminder':
        reminderMessage = 'Second Reminder: Time to be reminded!';
        break;
      case 'Final Reminder':
        reminderMessage = 'Final Reminder: Time to be reminded!';
        break;
    }

    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      "ReminderID",
      "Reminder",
      channelDescription:
          "This is to remind you about your credentials expiration.",
      importance: Importance.max,
      priority: Priority.high,
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    int notificationId;

    // Assign unique notification ID based on reminder type
    switch (reminderType) {
      case 'First Reminder':
        notificationId = 1;
        break;
      case 'Second Reminder':
        notificationId = 2;
        break;
      case 'Final Reminder':
        notificationId = 3;
        break;
      default:
        notificationId = 0; // Default ID
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId, // Use unique ID for each reminder type
      'Reminder',
      reminderMessage, // Notification body
      tz.TZDateTime.from(selectedDate, tz.local),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

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
          // Image upload for Front
          GestureDetector(
            onTap: () async {
              await showImageSourceDialog('front');
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
          // Image upload for Back
          GestureDetector(
            onTap: () async {
              await showImageSourceDialog('back');
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
                String? userId = authService.getCurrentUserId();
                if (_formKey.currentState?.validate() ?? false) {
                  setState(() {
                    isLoading = true;
                  });
                  // Assuming you have retrieved the values from the TextEditingController instances
                  String certificationName = certificationNameController.text;
                  String certificationNumber =
                      certificationNumberController.text;
                  String frontImageURL = frontImageUrl != null
                      ? await SaveDataService.uploadImageToStorage(
                          userId!, frontImageUrl!)
                      : '';
                  String backImageURL = backImageUrl != null
                      ? await SaveDataService.uploadImageToStorage(
                          userId!, backImageUrl!)
                      : '';

                  String certificationIssueDate =
                      certificationIssueDateController.text;
                  String certificationExpiryDate =
                      certificationExpiryDateController.text;
                  String certificationPrivateNote =
                      certificationPrivateNoteController.text;

                  // Call the saveCertificationData method with the gathered data
                  await CertificationService.saveCertificationData(
                    certificationName: certificationName,
                    certificationNumber: certificationNumber,
                    frontImageUrl: frontImageURL,
                    backImageUrl: backImageURL,
                    certificationIssueDate: certificationIssueDate,
                    certificationExpiryDate: certificationExpiryDate,
                    certificationPrivateNote: certificationPrivateNote,
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

  Future<void> showImageSourceDialog(String type) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  pickImageAndSetUrl(type, 'camera');
                },
                child: const Text('Camera'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  pickImageAndSetUrl(type, 'gallery');
                },
                child: const Text('Gallery'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> pickImageAndSetUrl(String type, String source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: source == 'camera' ? ImageSource.camera : ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        if (type == 'front') {
          frontImageUrl = pickedFile.path;
        } else {
          backImageUrl = pickedFile.path;
        }
      });
    }
  }
}
