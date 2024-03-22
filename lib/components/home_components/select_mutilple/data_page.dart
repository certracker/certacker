import 'package:certracker/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'selete_muiltple.dart';
import 'package:http/http.dart' as http;

class MultipleDataPage extends StatelessWidget {
  const MultipleDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchUserDataWithPdf(), // Call the updated function
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          List<Map<String, dynamic>> userData = snapshot.data ?? [];
          return SelectMultiple(data: userData);
        }
      },
    );
  }
}

Future<List<Map<String, dynamic>>> fetchUserDataWithPdf() async {
  try {
    String? userId = AuthenticationService().getCurrentUserId();

    if (userId != null) {
      List<QuerySnapshot> snapshots = await Future.wait([
        FirebaseFirestore.instance
            .collection('Certification')
            .where('userId', isEqualTo: userId)
            .get(),
        FirebaseFirestore.instance
            .collection('License')
            .where('userId', isEqualTo: userId)
            .get(),
        FirebaseFirestore.instance
            .collection('Education')
            .where('userId', isEqualTo: userId)
            .get(),
        FirebaseFirestore.instance
            .collection('Vaccination')
            .where('userId', isEqualTo: userId)
            .get(),
        FirebaseFirestore.instance
            .collection('Travel')
            .where('userId', isEqualTo: userId)
            .get(),
        FirebaseFirestore.instance
            .collection('CEU')
            .where('userId', isEqualTo: userId)
            .get(),
        FirebaseFirestore.instance
            .collection('Others')
            .where('userId', isEqualTo: userId)
            .get(),
      ]);
      List<Map<String, dynamic>> userData = [];
      for (QuerySnapshot snapshot in snapshots) {
        for (QueryDocumentSnapshot doc in snapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          String tableName = doc.reference.parent.id;
          data['tableName'] = tableName;
          data['timestamp'] = doc['timestamp'];

          // Download PDF and add its path to data
          String pdfUrl = data['FileDownloadUrl'];
          final response = await http.get(Uri.parse(pdfUrl));
          final bytes = response.bodyBytes;
          final appDir = await getApplicationDocumentsDirectory();
          final pdfPath = '${appDir.path}/${tableName}_${doc.id}.pdf'; // Unique file name for each PDF
          final pdfFile = File(pdfPath);
          await pdfFile.writeAsBytes(bytes);
          data['pdfPath'] = pdfPath;

          userData.add(data);
        }
      }
      return userData;
    } else {
      throw Exception('User not authenticated!');
    }
  } catch (e) {
    print('Error fetching user data: $e');
    rethrow;
  }
}
