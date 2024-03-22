import 'package:certracker/auth/auth_service.dart';
import 'package:certracker/auth/save_data_service.dart';

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
    required String name,
    required String number,
    required String issueDate,
    required String expiryDate,
    required String state,
    required String privateNote,
    required String filePath, // New parameter for file path
    // Add other necessary fields for License
  }) async {
    String tableName = 'License';
    String credentialsId = generateUniqueCredentialsId();
    String? userId = AuthenticationService().getCurrentUserId();

    if (userId != null) {
      Map<String, dynamic> data = {
        'Title': name.toLowerCase(),
        'Number': number,
        'IssueDate': issueDate,
        'ExpiryDate': expiryDate,
        'State': state,
        'PrivateNote': privateNote,
        // Add other fields for License
      };

      // Upload file to storage and get download URL
      String fileDownloadUrl =
          await SaveDataService.uploadFileToStorage(userId, filePath);

      // Add file download URL to data
      data['FileDownloadUrl'] = fileDownloadUrl;

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
