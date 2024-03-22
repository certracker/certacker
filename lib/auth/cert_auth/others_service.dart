import 'package:certracker/auth/auth_service.dart';
import 'package:certracker/auth/save_data_service.dart';

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
    required String name,
    required String number,
    required String issueDate,
    required String expiryDate,
    required String privateNote,
    required String filePath, // New parameter for file path
    // Add other necessary fields for Others
  }) async {
    String tableName = 'Others';
    String credentialsId = generateUniqueCredentialsId();
    String? userId = AuthenticationService().getCurrentUserId();

    if (userId != null) {
      Map<String, dynamic> data = {
        'Title': name.toLowerCase(),
        'Number': number,
        'IssueDate': issueDate,
        'ExpiryDate': expiryDate,
        'PrivateNote': privateNote,
        // Add other fields for Others
      };

      // Upload file to storage and get download URL
      String fileDownloadUrl =
          await SaveDataService.uploadFileToStorage(userId, filePath);

      // Add file download URL to data
      data['FileDownloadUrl'] = fileDownloadUrl;

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
