// import 'package:flutter/foundation.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class FlutterNotificationService {
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   Future<void> initNotifications() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings("app_icon");

//     const InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: initializationSettingsAndroid,
//     );

//     await flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//     );
//   }

//   Future<void> showNotification(
//       int id, String title, String body, NotificationDetails platformChannelSpecifics) async {
//     try {
//       await flutterLocalNotificationsPlugin.show(
//         id,
//         title,
//         body,
//         const NotificationDetails(
//           android: AndroidNotificationDetails(
//             "NotificationChannel",
//             "NotificationChannelForandroid",
//             importance: Importance.max,
//             priority: Priority.high,
//           ),
//         ),
//       );
//     } catch (e) {
//       if (kDebugMode) {
//         print("Error showing notification: $e");
//       }
//     }
//   }

//   // Add any additional notification-related methods or configuration here
// }



import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FlutterNotificationService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("app_icon");

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  Future<void> showNotification(
      int id, String title, String body, NotificationDetails platformChannelSpecifics) async {
    try {
      await flutterLocalNotificationsPlugin.show(
        id,
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            "NotificationChannel",
            "NotificationChannelForandroid",
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error showing notification: $e");
      }
    }
  }

  // Add any additional notification-related methods or configuration here
}
