import 'package:share_plus/share_plus.dart';
import 'package:certracker/auth/save_data_service.dart';
import 'dart:io';

class DeleteDataService {
  static Future<void> deleteSelectedData(List<Map<String, dynamic>> selectedItems) async {
    try {
      for (var item in selectedItems) {
        String tableName = item['tableName'];
        String credentialsId = item['credentialsId']; 
        
        await SaveDataService.deleteData(tableName, credentialsId);
      }
    } catch (e) {
      // Print all error information
      print('Error deleting data: $e');
      print('Selected items: $selectedItems');
      
      // Handle error as needed
    }
  }
}

void shareSelectedPDFs(List<Map<String, dynamic>> selectedItems) {
  List<String> pdfPaths = selectedItems.map((item) => item['pdfPath'] as String).toList();
  
  // Store the PDF paths locally in a list
  List<String> localPaths = [];
  for (String pdfPath in pdfPaths) {
    File pdfFile = File(pdfPath);
    if (pdfFile.existsSync()) {
      localPaths.add(pdfPath);
    } else {
      print('PDF file not found at path: $pdfPath');
    }
  }
  
  // Share the locally stored PDF files
  Share.shareFiles(localPaths, text: 'Sharing PDF files');
}
