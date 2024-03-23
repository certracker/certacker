
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_plus/share_plus.dart';


class DeleteDataService {
  static Future<void> deleteSelectedData(List<Map<String, dynamic>> selectedItems) async {
  try {
    // Initialize Firebase app
    await Firebase.initializeApp();

    // Iterate through selected items and delete them
    await Future.forEach(selectedItems, (item) async {
      String? tableName = item['tableName'];
      String? credentialsId = item['credentialsId'];
      
      if (tableName != null && credentialsId != null) {
        await deleteData(item);
      } else {
        print('Skipping deletion due to null values: tableName=$tableName, credentialsId=$credentialsId');
      }
    });
  } catch (e) {
    // Print error information
    print('Error deleting data: $e');
    print('Selected items: $selectedItems');
    
    
    // Handle error as needed
    throw e;
  }
}

static Future<void> deleteData(Map<String, dynamic> item) async {
  try {
    String tableName = item['tableName'];
    String credentialsId = item['credentialsId'];
  
    // Get Firestore collection reference
    CollectionReference tableCollection = FirebaseFirestore.instance.collection(tableName);

    // Get document reference
    DocumentReference documentReference = tableCollection.doc(credentialsId);

    // Delete the document
    await documentReference.delete();
  } catch (e) {
    print('Deleting document with credentialsId: ${item['credentialsId']}');
    
    throw Exception('Error deleting document: $e');
  }
}

}

void shareSelectedPDFs(List<Map<String, dynamic>> selectedItems) {
  List<String> pdfPaths = selectedItems.map((item) => item['pdfPath'] as String).toList();
  
  // Store the PDF paths locally in a list
  List<String> localPaths = [];
  for (String pdfPath in pdfPaths) {
    File pdfFile = File(pdfPath);
    if (pdfFile.existsSync()) {
      localPaths.add(pdfPath);
    } else {
      print('PDF file not found at path: $pdfPath');
    }
  }
  
  // Check if localPaths is not empty before sharing
  if (localPaths.isNotEmpty) {
    // Share the locally stored PDF files
    Share.shareFiles(localPaths, text: 'Sharing PDF files');
  } else {
    print('No PDF files found to share.');
  }
}
