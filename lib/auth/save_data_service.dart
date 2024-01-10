import 'package:certracker/auth/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

class SaveDataService {
  static Future<void> saveData({
    required String category,
    required Map<String, dynamic> data,
    required String userId,
  }) async {
    await Firebase.initializeApp();

    CollectionReference userCollection =
        FirebaseFirestore.instance.collection('users');
    DocumentReference userDocRef = userCollection.doc(userId);
    CollectionReference categoryCollection =
        userDocRef.collection('credentials').doc(category).collection('items');

    await categoryCollection.add(data);
  }

  static Future<String> uploadImageToStorage(String imagePath) async {
    Reference ref = FirebaseStorage.instance.ref().child(imagePath);
    // Replace this logic with your image upload logic
    // For example:
    // Upload a sample image from the assets folder
    final imageBytes = (await rootBundle.load(imagePath)).buffer.asUint8List();
    UploadTask uploadTask = ref.putData(imageBytes);

    TaskSnapshot snapshot = await uploadTask;
    String imageUrl = await snapshot.ref.getDownloadURL();

    return imageUrl;
  }
}

class CertificationService {
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
    String category = 'Certification';
    Map<String, dynamic> data = {
      'certificationName': certificationName,
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
      await SaveDataService.saveData(category: category, data: data, userId: userId);
    } else {
      // Handle if the user ID is null (user not authenticated)
      throw Exception('User not authenticated!');
    }
  }
}



class LicenseService {
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
    String category = 'License';
    Map<String, dynamic> data = {
      'licenseName': licenseName,
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

    // Get the current user's ID
    String? userId = AuthenticationService().getCurrentUserId();
    if (userId != null) {
      await SaveDataService.saveData(
        category: category,
        data: data,
        userId: userId,
      );
    } else {
      // Handle if the user ID is null (user not authenticated)
      throw Exception('User not authenticated!');
    }
  }
}


class EducationService {
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
    String category = 'Education';
    Map<String, dynamic> data = {
      'educationName': educationName,
      'educationDegree': educationDegree,
      'startDate': startDate,
      'educationField': educationField,
      'graduationDate': graduationDate,
      'educationPrivateNote': educationPrivateNote,
      'frontImageUrl': frontImageUrl,
      'backImageUrl': backImageUrl,
      // Add other fields for Education
    };

    String? userId = AuthenticationService().getCurrentUserId();
    if (userId != null) {
      await SaveDataService.saveData(
        category: category,
        data: data,
        userId: userId,
      );
    } else {
      throw Exception('User not authenticated!');
    }
  }
}


class VaccinationService {
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
    String category = 'Vaccination';
    Map<String, dynamic> data = {
      'vaccinationName': vaccinationType,
      'vaccinationDate': vaccinationManufacturer,
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

    String? userId = AuthenticationService().getCurrentUserId();
    if (userId != null) {
      await SaveDataService.saveData(
        category: category,
        data: data,
        userId: userId,
      );
    } else {
      throw Exception('User not authenticated!');
    }
  }
}


class TravelService {
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
    String category = 'Travel';
    Map<String, dynamic> data = {
      'frontImageUrl': frontImageUrl,
      'backImageUrl': backImageUrl,
      'travelCountry': travelCountry,
      'placeOfIssue': placeOfIssue,
      'documentNumber': documentNumber,
      'issueDate': issueDate,
      'expiryDate': expiryDate,
      'travelPrivateNote': travelPrivateNote,
      'documentType': documentType, // Include document type in data
      // Add other fields for Travel
    };

    String? userId = AuthenticationService().getCurrentUserId();
    if (userId != null) {
      await SaveDataService.saveData(
        category: category,
        data: data,
        userId: userId,
      );
    } else {
      throw Exception('User not authenticated!');
    }
  }
}


class CEUCMEService {
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
    String category = 'CEU';
    Map<String, dynamic> data = {
      'frontImageUrl': frontImageUrl,
      'backImageUrl': backImageUrl,
      'ceuProgramTitle': ceuProgramTitle,
      'ceuProviderName': ceuProviderName,
      'ceuNumberOfContactHour': ceuNumberOfContactHour,
      'ceuCompletionDate': ceuCompletionDate,
      'ceuPrivateNote': ceuPrivateNote,
      // Add other fields for CEU/CME
    };

    String? userId = AuthenticationService().getCurrentUserId();
    if (userId != null) {
      await SaveDataService.saveData(
        category: category,
        data: data,
        userId: userId,
      );
    } else {
      throw Exception('User not authenticated!');
    }
  }
}


class OthersService {
  static Future<void> saveOthersData({
    required String othersName,
    required String othersDetails,
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
    String category = 'Others';
    Map<String, dynamic> data = {
      'othersName': othersName,
      'othersDetails': othersDetails,
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

    String? userId = AuthenticationService().getCurrentUserId();
    if (userId != null) {
      await SaveDataService.saveData(
        category: category,
        data: data,
        userId: userId,
      );
    } else {
      throw Exception('User not authenticated!');
    }
  }
}
