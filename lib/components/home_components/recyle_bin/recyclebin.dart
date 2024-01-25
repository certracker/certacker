// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class RecycleBinPage extends StatefulWidget {
//   const RecycleBinPage({super.key});

//   @override
//   State<RecycleBinPage> createState() => _RecycleBinPageState();
// }

// class _RecycleBinPageState extends State<RecycleBinPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Recycle Bin"),
//         centerTitle: true,
//       ),
//       body: FutureBuilder(
//         future: fetchRecycleBinData(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (snapshot.hasData) {
//             List<Map<String, dynamic>> recycleBinData = snapshot.data as List<Map<String, dynamic>>;

//             if (recycleBinData.isEmpty) {
//               return const Center(child: Text('No documents in the Recycle Bin'));
//             } else {
//               return ListView.builder(
//                 itemCount: recycleBinData.length,
//                 itemBuilder: (context, index) {
//                   final documentData = recycleBinData[index];
//                   // Customize how to display each item from the Recycle Bin
//                   return ListTile(
//                     title: Text(documentData['yourFieldName']),
//                     // Add more widgets or customize as needed
//                   );
//                 },
//               );
//             }
//           } else {
//             return const Center(child: Text('No data available'));
//           }
//         },
//       ),
//     );
//   }

//   Future<List<Map<String, dynamic>>> fetchRecycleBinData() async {
//     try {
//       // Replace 'recyclebin' with your actual collection name
//       QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance.collection('recyclebin').get();

//       List<Map<String, dynamic>> recycleBinData = querySnapshot.docs.map((doc) => doc.data()).toList();
//       return recycleBinData;
//     } catch (e) {
//       print('Error fetching Recycle Bin data: $e');
//       rethrow;
//     }
//   }
// }

import 'package:certracker/components/notification/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // Import flutter_local_notifications// Replace with the correct import path for Noti class

class RecycleBinPage extends StatelessWidget {
  RecycleBinPage({super.key});

  // Initialize flutterLocalNotificationsPlugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recycle Bin"),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Show a test notification when the button is clicked
            Noti.showBigTextNotification(
              title: 'First Reminder',
              body: 'This is to Notify you of your Certificate Expiration',
              fln: flutterLocalNotificationsPlugin,
            );
          },
          child: const Text('Show Test Notification'),
        ),
      ),
    );
  }
}
