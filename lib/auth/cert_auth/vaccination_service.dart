import 'package:certracker/auth/auth_service.dart';
import 'package:certracker/auth/save_data_service.dart';

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
    required String manufacturer,
    required String lotNumber,
    required String issueDate,
    required String expiryDate,
    required String privateNote,
    required String filePath, // New parameter for file path
    // Add other necessary fields for Vaccination
  }) async {
    String tableName = 'Vaccination';
    String credentialsId = generateUniqueCredentialsId();
    String? userId = AuthenticationService().getCurrentUserId();

    if (userId != null) {
      Map<String, dynamic> data = {
        'Title': vaccinationType.toLowerCase(),
        'Manufacturer': manufacturer,
        'LotNumber': lotNumber,
        'IssueDate': issueDate,
        'ExpiryDate': expiryDate,
        'PrivateNote': privateNote,
        // Add other fields for Vaccination
      };

      // Upload file to storage and get download URL
      String fileDownloadUrl =
          await SaveDataService.uploadFileToStorage(userId, filePath);

      // Add file download URL to data
      data['FileDownloadUrl'] = fileDownloadUrl;

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
