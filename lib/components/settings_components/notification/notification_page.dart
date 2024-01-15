import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool inAppCredential = false;
  bool pushCredential = false;
  bool emailCredential = false;
  bool inAppReminder = false;
  bool pushReminder = false;
  bool emailReminder = false;
  bool textReminder = false;
  bool isButtonEnabled = false; // Track changes in checkboxes

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Manage Notification")),
        actions: <Widget>[
          GestureDetector(
            onTap: isButtonEnabled
                ? () {
                    // Add functionality to save notification preferences
                    _showSuccessfulDialog(context);
                    setState(() {
                      isButtonEnabled = false; // Reset button status
                    });
                  }
                : null, // Disable button if no changes are made
            child: Container(
              decoration: BoxDecoration(
                color: isButtonEnabled
                    ? const Color(0xFF39115B)
                    : Colors.grey, // Button background color
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Colors.white, // Text color
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Credential Notification",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "How do you want to receive notification on all your credentials?",
            ),
            CheckboxListTile(
              title: const Text('In-app'),
              value: inAppCredential,
              onChanged: (bool? value) {
                setState(() {
                  inAppCredential = value ?? false;
                  _checkButtonStatus();
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Push'),
              value: pushCredential,
              onChanged: (bool? value) {
                setState(() {
                  pushCredential = value ?? false;
                  _checkButtonStatus();
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Email'),
              value: emailCredential,
              onChanged: (bool? value) {
                setState(() {
                  emailCredential = value ?? false;
                  _checkButtonStatus();
                });
              },
            ),
            const SizedBox(height: 20),
            const Text(
              "Reminder Notification",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "How do you want to receive notification on your reminders?",
            ),
            CheckboxListTile(
              title: const Text('In-app'),
              value: inAppReminder,
              onChanged: (bool? value) {
                setState(() {
                  inAppReminder = value ?? false;
                  _checkButtonStatus();
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Push'),
              value: pushReminder,
              onChanged: (bool? value) {
                setState(() {
                  pushReminder = value ?? false;
                  _checkButtonStatus();
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Email'),
              value: emailReminder,
              onChanged: (bool? value) {
                setState(() {
                  emailReminder = value ?? false;
                  _checkButtonStatus();
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Text'),
              value: textReminder,
              onChanged: (bool? value) {
                setState(() {
                  textReminder = value ?? false;
                  _checkButtonStatus();
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _checkButtonStatus() {
    if (inAppCredential != false ||
        pushCredential != false ||
        emailCredential != false ||
        inAppReminder != false ||
        pushReminder != false ||
        emailReminder != false ||
        textReminder != false) {
      setState(() {
        isButtonEnabled = true;
      });
    } else {
      setState(() {
        isButtonEnabled = false;
      });
    }
  }

  void _showSuccessfulDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Success"),
          content: const Text("Changes have been saved successfully."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
