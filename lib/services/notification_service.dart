import 'package:flutter/foundation.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FlutterNotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    _firebaseMessaging.getToken().then((token) {
      if (kDebugMode) {
        print('FCM Token: $token');
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotificationFromFCM(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle when the app is opened from a terminated state
      showNotificationFromFCM(message);
    });

    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
  }

  Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    // Handle FCM messages when the app is in the background
    showNotificationFromFCM(message);
  }

  Future<void> showNotificationFromFCM(RemoteMessage message) async {
    final String title = message.notification?.title ?? '';
    final String body = message.notification?.body ?? '';

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your channel id',
          'your channel name',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false,
        ),
      ),
    );
  }

  Future<void> sendTestFCMMessage(
  String title,
  String note,
  DateTime scheduledDate,
  int notificationId,
  String userId,
) async {
  // Send a test FCM message to the specific user to simulate the server's push notification
  // This is for demonstration purposes only; replace it with your server implementation
  // Refer to Firebase Cloud Messaging documentation for server-side FCM setup

  // Subscribe to a topic specific to the user
  await _firebaseMessaging.subscribeToTopic('user_$userId');

  // Subscribe to a topic specific to the reminder
  await _firebaseMessaging.subscribeToTopic('reminder_$notificationId');

  // Convert DateTime to TZDateTime
  final scheduledDateTime = tz.TZDateTime.from(
    scheduledDate,
    tz.local,
  );

  await flutterLocalNotificationsPlugin.zonedSchedule(
    notificationId,
    title,
    note,
    scheduledDateTime,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'your channel id',
        'your channel name',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false,
      ),
    ),
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
  );
}

}
