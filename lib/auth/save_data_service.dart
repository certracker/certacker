import 'dart:io';

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

      print('Document deleted successfully!');
    } catch (e) {
      print('Error deleting document: $e');
      throw Exception('Error deleting document');
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

          print('Updating document with ID: $credentialsId');
          print('Existing data: $existingData');
          print('Updated data: $updatedData');

          // Update the document
          await documentReference.update(newData);

          print('Document updated successfully!');
        } else {
          // Throw an exception if the current user is not the owner
          print('Current user does not have permission to edit this credential.');
          throw Exception('Permission denied.');
        }
      } else {
        // Handle the case where no document with the specified ID is found
        print('Document with ID $credentialsId not found.');
        throw Exception('Document not found.');
      }
    } catch (e) {
      // Handle error
      print('Error updating document: $e');
      throw Exception('Error updating document');
    }
  }

  static String generateUniqueCredentialsId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  static Future<String> uploadImageToStorage(String imagePath) async {
    if (imagePath.isEmpty) {
      return ''; // Return an empty string for empty image paths
    }

    try {
      Reference ref = FirebaseStorage.instance.ref().child(imagePath);
      final File imageFile = File(imagePath);

      // Read the file as bytes
      List<int> imageBytes = await imageFile.readAsBytes();

      // Convert List<int> to Uint8List
      Uint8List uint8List = Uint8List.fromList(imageBytes);

      // Upload the bytes to Firebase Storage
      TaskSnapshot snapshot = await ref.putData(uint8List);
      String imageUrl = await snapshot.ref.getDownloadURL();

      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      throw Exception('Error uploading image');
    }
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

class CertificationService {
  static Future<void> updateCertificationData({
    required String credentialsId,
    required String userId,
    required Map<String, dynamic> updatedData,
  }) async {
    String tableName = 'Certification';

    await SaveDataService.updateData(
      tableName: tableName,
      userId: userId,
      credentialsId: credentialsId,
      updatedData: updatedData,
    );
  }

  static Future<void> saveCertificationData({
    required String certificationName,
    required String certificationNumber,
    required String frontImageUrl,
    required String backImageUrl,
    required String certificationIssueDate,
    required String certificationExpiryDate,
    required String certificationFirstReminder,
    required String certificationSecondReminder,
    required String certificationFinalReminder,
    required String certificationPrivateNote,
    // Add other necessary fields for Certification
  }) async {
    String tableName = 'Certification';
    String credentialsId = SaveDataService.generateUniqueCredentialsId();
    Map<String, dynamic> data = {
      'Title': certificationName.toLowerCase(),
      'certificationNumber': certificationNumber,
      'frontImageUrl': frontImageUrl,
      'backImageUrl': backImageUrl,
      'certificationIssueDate': certificationIssueDate,
      'certificationExpiryDate': certificationExpiryDate,
      'certificationFirstReminder': certificationFirstReminder,
      'certificationSecondReminder': certificationSecondReminder,
      'certificationFinalReminder': certificationFinalReminder,
      'certificationPrivateNote': certificationPrivateNote,
      // Add other fields for Certification
    };

    // Get the current user's ID
    String? userId = AuthenticationService().getCurrentUserId();
    if (userId != null) {
      await SaveDataService.saveData(
        tableName: tableName,
        data: data,
        userId: userId,
        credentialsId: credentialsId,
      );
    } else {
      // Handle if the user ID is null (user not authenticated)
      throw Exception('User not authenticated!');
    }
  }

  // A placeholder method for generating unique credentialsId
  static String generateUniqueCredentialsId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}

class LicenseService {
  static Future<void> updateLicenseData({
    required String credentialsId,
    required String userId,
    required Map<String, dynamic> updatedData,
  }) async {
    String tableName = 'License';

    await SaveDataService.updateData(
      tableName: tableName,
      userId: userId,
      credentialsId: credentialsId,
      updatedData: updatedData,
    );
  }

  static Future<void> saveLicenseData({
    required String licenseName,
    required String licenseNumber,
    required String frontImageUrl,
    required String backImageUrl,
    required String licenseIssueDate,
    required String licenseExpiryDate,
    required String licenseFirstReminder,
    required String licenseSecondReminder,
    required String licenseFinalReminder,
    required String licensePrivateNote,
    required String licenseState,
    // Add other necessary fields for License
  }) async {
    String tableName = 'License';
    String credentialsId = generateUniqueCredentialsId();
    String? userId = AuthenticationService().getCurrentUserId();

    if (userId != null) {
      Map<String, dynamic> data = {
        'Title': licenseName.toLowerCase(),
        'licenseNumber': licenseNumber,
        'frontImageUrl': frontImageUrl,
        'backImageUrl': backImageUrl,
        'licenseIssueDate': licenseIssueDate,
        'licenseExpiryDate': licenseExpiryDate,
        'licenseFirstReminder': licenseFirstReminder,
        'licenseSecondReminder': licenseSecondReminder,
        'licenseFinalReminder': licenseFinalReminder,
        'licensePrivateNote': licensePrivateNote,
        'licenseState': licenseState,
        // Add other fields for License
      };

      // Save license data to the database
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

  // A placeholder method for generating unique credentialsId
  static String generateUniqueCredentialsId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}


class EducationService {
  static Future<void> updateEducationData({
    required String credentialsId,
    required String userId,
    required Map<String, dynamic> updatedData,
  }) async {
    String tableName = 'Education';

    await SaveDataService.updateData(
      tableName: tableName,
      userId: userId,
      credentialsId: credentialsId,
      updatedData: updatedData,
    );
  }

  static Future<void> saveEducationData({
    required String educationName,
    required String educationDegree,
    required String startDate,
    required String educationField,
    required String graduationDate,
    required String educationPrivateNote,
    required String frontImageUrl,
    required String backImageUrl,
    // Add other necessary fields for Education
  }) async {
    String tableName = 'Education';
    String credentialsId = generateUniqueCredentialsId();
    String? userId = AuthenticationService().getCurrentUserId();

    if (userId != null) {
      Map<String, dynamic> data = {
        'Title': educationName.toLowerCase(),
        'educationDegree': educationDegree,
        'startDate': startDate,
        'educationField': educationField,
        'graduationDate': graduationDate,
        'educationPrivateNote': educationPrivateNote,
        'frontImageUrl': frontImageUrl,
        'backImageUrl': backImageUrl,
        // Add other fields for Education
      };

      // Save education data to the database
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

  // A placeholder method for generating unique credentialsId
  static String generateUniqueCredentialsId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}


class CEUCMEService {
  static Future<void> updateCEUData({
    required String credentialsId,
    required String userId,
    required Map<String, dynamic> updatedData,
  }) async {
    String tableName = 'CEU';

    await SaveDataService.updateData(
      tableName: tableName,
      userId: userId,
      credentialsId: credentialsId,
      updatedData: updatedData,
    );
  }

  static Future<void> saveCEUData({
    required String frontImageUrl,
    required String backImageUrl,
    required String ceuProgramTitle,
    required String ceuProviderName,
    required String ceuNumberOfContactHour,
    required String ceuCompletionDate,
    required String ceuPrivateNote,
    // Add other necessary fields for CEU/CME
  }) async {
    String tableName = 'CEU';
    String credentialsId = generateUniqueCredentialsId();
    String? userId = AuthenticationService().getCurrentUserId();

    if (userId != null) {
      Map<String, dynamic> data = {
        'frontImageUrl': frontImageUrl,
        'backImageUrl': backImageUrl,
        'Title': ceuProgramTitle.toLowerCase(),
        'ceuProviderName': ceuProviderName,
        'ceuNumberOfContactHour': ceuNumberOfContactHour,
        'ceuCompletionDate': ceuCompletionDate,
        'ceuPrivateNote': ceuPrivateNote,
        // Add other fields for CEU/CME
      };

      // Save CEU/CME data to the database
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

  // A placeholder method for generating unique credentialsId
  static String generateUniqueCredentialsId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}


class OthersService {
  static Future<void> updateOthersData({
    required String credentialsId,
    required String userId,
    required Map<String, dynamic> updatedData,
  }) async {
    String tableName = 'Others';

    await SaveDataService.updateData(
      tableName: tableName,
      userId: userId,
      credentialsId: credentialsId,
      updatedData: updatedData,
    );
  }

  static Future<void> saveOthersData({
    required String othersName,
    // required String othersDetails,
    required String frontImageUrl,
    required String backImageUrl,
    required String otherNumber,
    required String otherIssueDate,
    required String otherExpiryDate,
    required String otherFirstReminder,
    required String otherSecondReminder,
    required String otherFinalReminder,
    required String otherPrivateNote,
    // Add other necessary fields for Others
  }) async {
    String tableName = 'Others';
    String credentialsId = generateUniqueCredentialsId();
    String? userId = AuthenticationService().getCurrentUserId();

    if (userId != null) {
      Map<String, dynamic> data = {
        'Title': othersName.toLowerCase(),
        // 'othersDetails': othersDetails,
        'frontImageUrl': frontImageUrl,
        'backImageUrl': backImageUrl,
        'otherNumber': otherNumber,
        'otherIssueDate': otherIssueDate,
        'otherExpiryDate': otherExpiryDate,
        'otherFirstReminder': otherFirstReminder,
        'otherSecondReminder': otherSecondReminder,
        'otherFinalReminder': otherFinalReminder,
        'otherPrivateNote': otherPrivateNote,
        // Add other fields for Others
      };

      // Save Others data to the database
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

  // A placeholder method for generating unique credentialsId
  static String generateUniqueCredentialsId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}


class TravelService {
  static Future<void> updateTravelData({
  required String userId,
  required String credentialsId,
  required Map<String, dynamic> updatedData,
}) async {
  String tableName = 'Travel';

  await SaveDataService.updateData(
    tableName: tableName,
    userId: userId,
    credentialsId: credentialsId,
    updatedData: updatedData,
  );
}

  static Future<void> saveTravelData({
    required String frontImageUrl,
    required String backImageUrl,
    required String travelCountry,
    required String placeOfIssue,
    required String documentNumber,
    required String issueDate,
    required String expiryDate,
    required String travelPrivateNote,
    required String documentType,
    // Add other necessary fields for Travel
  }) async {
    String tableName = 'Travel';
    String credentialsId = generateUniqueCredentialsId();
    String? userId = AuthenticationService().getCurrentUserId();

    if (userId != null) {
      Map<String, dynamic> data = {
        'frontImageUrl': frontImageUrl,
        'backImageUrl': backImageUrl,
        'travelCountry': travelCountry,
        'placeOfIssue': placeOfIssue,
        'documentNumber': documentNumber,
        'issueDate': issueDate,
        'expiryDate': expiryDate,
        'travelPrivateNote': travelPrivateNote,
        'Title': documentType.toLowerCase(),
        // Add other fields for Travel
      };

      // Save Travel data to the database
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

  // A placeholder method for generating unique credentialsId
  static String generateUniqueCredentialsId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}


class VaccinationService {
  static Future<void> updateVaccinationData({
   required String userId,
  required String credentialsId,
  required Map<String, dynamic> updatedData,
}) async {
  String tableName = 'Vaccination';

  await SaveDataService.updateData(
    tableName: tableName,
    userId: userId,
    credentialsId: credentialsId,
    updatedData: updatedData,
  );
}

  static Future<void> saveVaccinationData({
    required String vaccinationType,
    required String vaccinationManufacturer,
    required String frontImageUrl,
    required String backImageUrl,
    required String vaccineType,
    required String vaccineManufacturer,
    required String vaccineLotNumber,
    required String vaccineIssueDate,
    required String vaccineExpiryDate,
    required String vaccinePrivateNote,
    // Add other necessary fields for Vaccination
  }) async {
    String tableName = 'Vaccination';
    String credentialsId = generateUniqueCredentialsId();
    String? userId = AuthenticationService().getCurrentUserId();

    if (userId != null) {
      Map<String, dynamic> data = {
        'Title': vaccinationType.toLowerCase(),
        'vaccinationManufacturer': vaccinationManufacturer,
        'frontImageUrl': frontImageUrl,
        'backImageUrl': backImageUrl,
        'vaccineType': vaccineType,
        'vaccineManufacturer': vaccineManufacturer,
        'vaccineLotNumber': vaccineLotNumber,
        'vaccineIssueDate': vaccineIssueDate,
        'vaccineExpiryDate': vaccineExpiryDate,
        'vaccinePrivateNote': vaccinePrivateNote,
        // Add other fields for Vaccination
      };

      // Save Vaccination data to the database
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

  // A placeholder method for generating unique credentialsId
  static String generateUniqueCredentialsId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
