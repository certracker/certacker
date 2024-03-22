import 'package:certracker/auth/auth_service.dart';
import 'package:certracker/auth/save_data_service.dart';

class CertificationService {
  static Future<void> updateCertificationData({
    required String credentialsId,
    required String userId,
    required Map<String, dynamic> updatedData,
    String? newFilePath, // New file path for updating
  }) async {
    String tableName = 'Certification';

    if (newFilePath != null) {
      // Upload new file to storage and get download URL
      String fileDownloadUrl = await SaveDataService.uploadFileToStorage(userId, newFilePath);

      // Add file download URL to updatedData
      updatedData['FileDownloadUrl'] = fileDownloadUrl;
    }

    await SaveDataService.updateData(
      tableName: tableName,
      userId: userId,
      credentialsId: credentialsId,
      updatedData: updatedData,
    );
  }

  static Future<void> saveCertificationData({
    required String name,
    required String number,
    required String issueDate,
    required String expiryDate,
    required String privateNote,
    required String filePath,
  }) async {
    String tableName = 'Certification';
    String credentialsId = SaveDataService.generateUniqueCredentialsId();
    Map<String, dynamic> data = {
      'Title': name.toLowerCase(),
      'Number': number,
      'IssueDate': issueDate,
      'ExpiryDate': expiryDate,
      'PrivateNote': privateNote,
      // Add other necessary fields for Certification
    };

    // Get the current user's ID
    String? userId = AuthenticationService().getCurrentUserId();
    if (userId != null) {
      // Upload file to storage and get download URL
      String fileDownloadUrl = await SaveDataService.uploadFileToStorage(userId, filePath);

      // Add file download URL to data
      data['FileDownloadUrl'] = fileDownloadUrl;

      // Save certification data to the database
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
