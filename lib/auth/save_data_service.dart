import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as path;
import 'package:image/image.dart' as img;
import 'package:pdf/widgets.dart' as pdfwidgets;
import 'package:certracker/auth/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

class SaveDataService {
  static Future<void> saveData({
    required String tableName,
    required Map<String, dynamic> data,
    required String userId,
    required String credentialsId,
  }) async {
    await Firebase.initializeApp();

    // Create a new collection for the table (e.g., 'Certification')
    CollectionReference tableCollection = FirebaseFirestore.instance.collection(
      tableName,
    );

    // Create a new document under the collection with the unique credentials ID
    DocumentReference documentReference = tableCollection.doc(credentialsId);

    // Add the user ID as a field inside the document
    data['userId'] = userId;

    // Add a timestamp field with the current server timestamp
    data['timestamp'] = FieldValue.serverTimestamp();

    await documentReference.set(data);
  }

  static Future<void> deleteData(String tableName, String credentialsId) async {
    try {
      await Firebase.initializeApp();

      CollectionReference tableCollection =
          FirebaseFirestore.instance.collection(tableName);

      DocumentReference documentReference = tableCollection.doc(credentialsId);

      // Delete the document
      await documentReference.delete();
    } catch (e) {
      print('Deleting document with credentialsId: $credentialsId');
      
      throw Exception('Error deleting document: $e');
    }
  }

  static Future<void> updateData({
    required String tableName,
    required String userId,
    required String credentialsId,
    required Map<String, dynamic> updatedData,
  }) async {
    await Firebase.initializeApp();

    CollectionReference tableCollection =
        FirebaseFirestore.instance.collection(tableName);

    DocumentReference documentReference = tableCollection.doc(credentialsId);

    try {
      // Get existing data
      DocumentSnapshot documentSnapshot = await documentReference.get();
      if (documentSnapshot.exists) {
        Map<String, dynamic> existingData =
            documentSnapshot.data()! as Map<String, dynamic>;

        // Check if the current user is the owner of the credential
        if (existingData['userId'] == userId) {
          // Merge existing data with updated data
          Map<String, dynamic> newData = {...existingData, ...updatedData};

          // Update the document
          await documentReference.update(newData);
        } else {
          // Throw an exception if the current user is not the owner
          throw Exception('Permission denied.');
        }
      } else {
        // Handle the case where no document with the specified ID is found

        throw Exception('Document not found.');
      }
    } catch (e) {
      // Handle error
      throw Exception('Error updating document');
    }
  }

  static String generateUniqueCredentialsId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  static Future<String> uploadFileToStorage(
      String userId, String filePath) async {
    if (filePath.isEmpty) {
      return ''; // Return an empty string for empty file paths
    }

    try {
      // Create the path with "credentials_files/userId/"
      String storagePath = 'credentials_files/$userId/';
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('$storagePath${path.basenameWithoutExtension(filePath)}.pdf');

      final file = File(filePath);

      if (path.extension(filePath).toLowerCase() == '.pdf') {
        // If the file is already a PDF, directly upload it
        await ref.putFile(file);
      } else {
        // If the file is an image, convert it to PDF before uploading
        Uint8List? pdfBytes;
        if (path.extension(filePath).toLowerCase() == '.jpeg' ||
            path.extension(filePath).toLowerCase() == '.jpg' ||
            path.extension(filePath).toLowerCase() == '.png') {
          pdfBytes = await convertImageToPdf(file);
        } else if (path.extension(filePath).toLowerCase() == '.doc') {
          // Handle conversion of doc to PDF if needed
          // Example: pdfBytes = await convertDocToPdf(file);
          throw UnsupportedError('Converting doc to PDF is not implemented.');
        } else {
          throw UnsupportedError(
              'Unsupported file format: ${path.extension(filePath)}');
        }

        // Upload the PDF bytes to Firebase Storage
        await ref.putData(pdfBytes);
      }

      // Get the download URL of the uploaded file
      final String downloadURL = await ref.getDownloadURL();

      return downloadURL;
    } catch (e) {
      throw Exception('Error uploading file');
    }
  }

  static Future<Uint8List> convertImageToPdf(File imageFile) async {
    final imageBytes = await imageFile.readAsBytes();
    final img.Image image = img.decodeImage(imageBytes)!;

    final pdfDoc = pdfwidgets.Document();
    final pdfImage = pdfwidgets.MemoryImage(
      img.encodeJpg(image, quality: 100),
    );

    pdfDoc.addPage(
      pdfwidgets.Page(
        build: (context) {
          return pdfwidgets.Center(
            child: pdfwidgets.Image(pdfImage),
          );
        },
      ),
    );

    return await pdfDoc.save();
  }
}

class DynamicTableService {
  static Future<void> saveDataToTable({
    required String title,
    required String tableName,
    required Map<String, dynamic> data,
  }) async {
    String credentialsId = SaveDataService.generateUniqueCredentialsId();
    String? userId = AuthenticationService().getCurrentUserId();

    if (userId != null) {
      data['Title'] = title;
      await SaveDataService.saveData(
        tableName: tableName,
        data: data,
        userId: userId,
        credentialsId: credentialsId,
      );
    } else {
      throw Exception('User not authenticated!');
    }
  }
}

class CategoryService {
  static Future<List<Map<String, dynamic>>> getAllCategories() async {
    await Firebase.initializeApp();

    CollectionReference categoriesCollection =
        FirebaseFirestore.instance.collection('categories');

    QuerySnapshot categoriesSnapshot = await categoriesCollection.get();

    return categoriesSnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }
}

