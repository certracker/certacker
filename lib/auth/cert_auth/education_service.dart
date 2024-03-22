import 'package:certracker/auth/auth_service.dart';
import 'package:certracker/auth/save_data_service.dart';

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
    required String name,
    required String degree,
    required String field,
    required String graduationDate,
    required String privateNote,
    required String filePath, // New parameter for file path
    // Add other necessary fields for Education
  }) async {
    String tableName = 'Education';
    String credentialsId = generateUniqueCredentialsId();
    String? userId = AuthenticationService().getCurrentUserId();

    if (userId != null) {
      Map<String, dynamic> data = {
        'Title': name.toLowerCase(),
        'Degree': degree,
        'Field': field,
        'GraduationDate': graduationDate,
        'PrivateNote': privateNote,
        // Add other fields for Education
      };

      // Upload file to storage and get download URL
      String fileDownloadUrl =
          await SaveDataService.uploadFileToStorage(userId, filePath);

      // Add file download URL to data
      data['FileDownloadUrl'] = fileDownloadUrl;

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
