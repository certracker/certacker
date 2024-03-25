import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0XFF591A8F),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              notifications[index].title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notifications[index].message),
                const SizedBox(height: 5),
                Text(
                  notifications[index].timestamp,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Notification model
class NotificationModel {
  final String title;
  final String message;
  final String timestamp;

  NotificationModel({
    required this.title,
    required this.message,
    required this.timestamp,
  });
}

// Sample notification data
List<NotificationModel> notifications = [
  NotificationModel(
    title: 'New Message',
    message: 'You have a new message from John Doe.',
    timestamp: 'Just now',
  ),
  NotificationModel(
    title: 'Event Reminder',
    message: 'Reminder: Team meeting at 10:00 AM tomorrow.',
    timestamp: 'Yesterday',
  ),
  NotificationModel(
    title: 'Payment Received',
    message: 'You received a payment of \$50 from Jane Smith.',
    timestamp: '2 days ago',
  ),
];
