import 'package:certracker/auth/auth_service.dart';
import 'package:certracker/auth/save_data_service.dart';

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
    required String documentType,
    required String country,
    required String placeOfIssue,
    required String documentNumber,
    required String issueDate,
    required String expiryDate,
    required String privateNote,
    required String filePath, // New parameter for file path
    // Add other necessary fields for Travel
  }) async {
    String tableName = 'Travel';
    String credentialsId = generateUniqueCredentialsId();
    String? userId = AuthenticationService().getCurrentUserId();

    if (userId != null) {
      Map<String, dynamic> data = {
        'Title': documentType.toLowerCase(),
        'Country': country,
        'placeOfIssue': placeOfIssue,
        'documentNumber': documentNumber,
        'issueDate': issueDate,
        'expiryDate': expiryDate,
        'PrivateNote': privateNote,
        // Add other fields for Travel
      };

      // Upload file to storage and get download URL
      String fileDownloadUrl =
          await SaveDataService.uploadFileToStorage(userId, filePath);

      // Add file download URL to data
      data['FileDownloadUrl'] = fileDownloadUrl;

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
