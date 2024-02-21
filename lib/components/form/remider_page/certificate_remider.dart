import 'package:certracker/components/nav_bar/nav_bar.dart';
import 'package:certracker/services/notification_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class SetReminderPage extends StatefulWidget {
  final String certificationName;
  final String certificationExpiryDate;

  const SetReminderPage({
    super.key,
    required this.certificationName,
    required this.certificationExpiryDate,
  });

  @override
  State<SetReminderPage> createState() => _SetReminderPageState();
}

class _SetReminderPageState extends State<SetReminderPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;

  late FlutterNotificationService notificationService;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();
    notificationService = FlutterNotificationService();
    notificationService.initNotifications();
  }

  Future<void> pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      String title = _titleController.text;
      String note = _noteController.text;
      DateTime scheduledDate = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      // Schedule reminder
      _scheduleReminder(title, note, scheduledDate);

      // Show success message
      _showSnackBar("Reminder set successfully", true);

      // Navigate to the main page after a short delay
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavBar()),
        ); // Assuming the main page is the previous page
      });
    }
  }

  void _showSnackBar(String message, bool isSuccess) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: isSuccess ? Colors.green : Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Future<void> _scheduleReminder(
  //     String title, String note, DateTime scheduledDate) async {
  //   const int notificationId = 0;
  //   final DateTime now = DateTime.now();
  //   final Duration timeDifference = scheduledDate.difference(now);
  //   final int seconds = timeDifference.inSeconds;

  //   if (seconds > 0) {
  //   const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
  //     "NotificationChannel",
  //     "NotificationChannelForandroid",
  //     importance: Importance.max,
  //     priority: Priority.high,
  //     showWhen: false, // Do not show the timestamp in the notification
  //   );

  //    const NotificationDetails platformChannelSpecifics =
  //       NotificationDetails(android: androidPlatformChannelSpecifics);

  //   final String notificationBody = "$title\n$note"; // Combine title and note in the notification body

  //   Future.delayed(Duration(seconds: seconds), () {
  //     notificationService.showNotification(notificationId, title, notificationBody, platformChannelSpecifics);
  //   });

  //     if (kDebugMode) {
  //       print('Reminder scheduled: $title, $note, $scheduledDate');
  //       print('Setting up reminder: $title, $note, $scheduledDate');
  //       print('Time difference: $timeDifference');
  //       print('Seconds: $seconds');
  //     }
  //   } else {
  //     if (kDebugMode) {
  //       print('Invalid scheduled date, please choose a future date and time.');
  //     }
  //   }
  // }

  Future<void> _scheduleReminder(String title, String note, DateTime scheduledDate) async {
  final int notificationId = DateTime.now().millisecondsSinceEpoch % (1 << 31); // Ensure the ID stays within the range
  final DateTime now = DateTime.now();
  final Duration timeDifference = scheduledDate.difference(now);
  final int seconds = timeDifference.inSeconds;

  if (seconds > 0) {
    Future.delayed(Duration(seconds: seconds), () {
      notificationService.showNotification(notificationId, title, "$title\n$note" , const NotificationDetails(
        android: AndroidNotificationDetails(
          "ReminderID",
          "Reminder",
        )
      ));
    });

    if (kDebugMode) {
      print('Reminder scheduled: $title, $note, $scheduledDate');
      print('Setting up reminder: $title, $note, $scheduledDate');
      print('Time difference: $timeDifference');
      print('Seconds: $seconds');
    }
  } else {
    if (kDebugMode) {
      print('Invalid scheduled date, please choose a future date and time.');
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Set Reminder"),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        children: [
          Image.asset("assets/images/forgetpassword/4.png"),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter a title";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _noteController,
                    decoration: const InputDecoration(labelText: 'Note'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter a note";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => pickDate(context),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: "Date",
                              border: OutlineInputBorder(),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${_selectedDate.toLocal()}".split(' ')[0],
                                ),
                                const Icon(Icons.calendar_today),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 25),
                      Expanded(
                        child: InkWell(
                          onTap: () => pickTime(context),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: "Time",
                              border: OutlineInputBorder(),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_selectedTime.format(context)),
                                const Icon(Icons.access_time),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 34),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 4,
                    ),
                    child: const Text(
                      "Set Reminder",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
