import 'package:certracker/auth/auth_service.dart';
import 'package:certracker/auth/save_data_service.dart';

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
    required String title,
    required String name,
    required String numberOfContactHour,
    required String completionDate,
    required String privateNote,
    required String filePath, // New parameter for file path
    // Add other necessary fields for CEU/CME
  }) async {
    String tableName = 'CEU';
    String credentialsId = generateUniqueCredentialsId();
    String? userId = AuthenticationService().getCurrentUserId();

    if (userId != null) {
      Map<String, dynamic> data = {
        'Title': title.toLowerCase(),
        'Name': name,
        'Number_Of_Contact_Hour': numberOfContactHour,
        'Completion_Date': completionDate,
        'PrivateNote': privateNote,
        // Add other fields for CEU/CME
      };

      // Upload file to storage and get download URL
      String fileDownloadUrl =
          await SaveDataService.uploadFileToStorage(userId, filePath);

      // Add file download URL to data
      data['FileDownloadUrl'] = fileDownloadUrl;

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
