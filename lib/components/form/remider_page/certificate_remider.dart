import 'package:certracker/auth/auth_service.dart';
import 'package:certracker/components/nav_bar/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:certracker/services/notification_service.dart';

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
    }
  }

  void _scheduleReminder(String title, String note, DateTime scheduledDate) {
    final int notificationId = DateTime.now().millisecondsSinceEpoch.hashCode;

    final DateTime now = DateTime.now();
    final Duration timeDifference = scheduledDate.difference(now);
    final int seconds = timeDifference.inSeconds;

    // Show success message immediately
    _showSnackBar("Reminder set successfully", true);

    // Navigate to the main page after a short delay
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BottomNavBar()),
      ); // Assuming the main page is the previous page
    });
    // Get the current user ID
    String? userId = AuthenticationService().getCurrentUserId();
    // Schedule the FCM message and local notification
    if (seconds > 0 && userId != null) {
      Future.delayed(Duration(seconds: seconds), () {
        notificationService.sendTestFCMMessage(
          title,
          note,
          scheduledDate,
          notificationId,
          userId,
        );
      });
    } else {
      _showSnackBar(
        "Invalid scheduled date, please choose a future date and time.",
        false,
      );
    }
  }

  void _showSnackBar(String message, bool isSuccess) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: isSuccess ? Colors.green : Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
