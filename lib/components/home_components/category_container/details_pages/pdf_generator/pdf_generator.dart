// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:pdf/widgets.dart' as pw;
// import 'package:pdf/pdf.dart' as pdfLib;
// import 'package:path_provider/path_provider.dart';
// import 'package:share_plus/share_plus.dart';

// class PdfGenerator {
//   static Future<void> generatePdf(Map<String, dynamic> details, String category) async {
//     try {
//       // Create PDF document
//       final pdf = pw.Document();

//       // Use a switch statement or a map to determine which details page to use
//       pw.Widget pdfContent;
//       switch (category) {
//         case 'Certification':
//           pdfContent = CertificationDetails(details: details).buildPdfContent();
//           break;
//         // Add cases for other categories like 'License', 'Education', etc.

//         default:
//           throw Exception('PDF content not available for this category.');
//       }

//       pdf.addPage(pw.Page(build: (pw.Context context) => pdfContent));

//       // Save PDF to a temporary file
//       final tempPath = (await getTemporaryDirectory()).path;
//       final pdfFile = File('$tempPath/${category.toLowerCase()}_details.pdf');
//       await pdfFile.writeAsBytes(await pdf.save());

//       // Share the PDF file
//       await Share.shareFiles([pdfFile.path], text: '$category Details PDF');
//     } catch (e) {
//       print('Error generating and sharing details: $e');
//     }
//   }
// }

// class CertificationDetails {
//   final Map<String, dynamic> details;

//   CertificationDetails({required this.details});

//   pw.Widget buildPdfContent() {
//     return pw.Column(
//       children: [
//         _buildPdfRow(['Credential Name', details['Title']],
//             ['Credential Record Number', details['certificationNumber']]),
//         pw.SizedBox(height: 16.0),
//         _buildPdfRow(
//           ['First Reminder', details['certificationFirstReminder']],
//           ['Second Reminder', details['certificationSecondReminder']],
//           ['Final Reminder', details['certificationFinalReminder']],
//         ),
//         pw.SizedBox(height: 16.0),
//         _buildPdfRow(['Issue Date', details['certificationIssueDate']],
//             ['Expiry Date', details['certificationExpiryDate']]),
//         pw.SizedBox(height: 16.0),
//         _buildPdfImageColumn('Front Image', details['frontImageUrl']),
//         pw.SizedBox(height: 16.0),
//         _buildPdfImageColumn('Back Image', details['backImageUrl']),
//       ],
//     );
//   }

//   pw.Widget _buildPdfRow(List<String> leftFields, List<dynamic> leftValues,
//       [List<String>? rightFields, List<dynamic>? rightValues]) {
//     return pw.Row(
//       children: [
//         pw.Expanded(child: _buildPdfFieldColumn(leftFields, leftValues)),
//         if (rightFields != null && rightValues != null)
//           pw.Expanded(child: _buildPdfFieldColumn(rightFields, rightValues)),
//       ],
//     );
//   }

//   pw.Widget _buildPdfFieldColumn(List<String> fields, List<dynamic> values) {
//     return pw.Column(
//       crossAxisAlignment: pw.CrossAxisAlignment.start,
//       children: List.generate(fields.length, (index) {
//         return pw.Column(
//           crossAxisAlignment: pw.CrossAxisAlignment.start,
//           children: [
//             pw.Text(
//               fields[index], // Field name
//               style: const pw.TextStyle(
//                 fontSize: 14.0,
//               ),
//             ),
//             pw.SizedBox(height: 8.0),
//             pw.Text(
//               values[index].toString(), // Field value
//               style: pw.TextStyle(
//                 fontSize: 16.0,
//                 fontWeight: pw.FontWeight.bold,
//               ),
//             ),
//             pw.SizedBox(height: 16.0),
//           ],
//         );
//       }),
//     );
//   }

//   pw.Widget _buildPdfImageColumn(String title, String imageUrl) {
//     return pw.Column(
//       crossAxisAlignment: pw.CrossAxisAlignment.start,
//       children: [
//         pw.Text(
//           title,
//           style: const pw.TextStyle(
//             fontSize: 14.0,
//           ),
//         ),
//         pw.SizedBox(height: 8.0),
//         pw.Container(
//           width: 150,
//           height: 150,
//           child: pw.FutureBuilder<pw.Image>(
//             future: _getImage(imageUrl),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == pwLib.ConnectionState.done) {
//                 return snapshot.data!;
//               } else {
//                 return pw.LoadingIndicator(); // Adjust this to fit your UI
//               }
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Future<pw.Image> _getImage(String imageUrl) async {
//     final imageBytes = await http
//         .get(Uri.parse(imageUrl))
//         .then((response) => response.bodyBytes);
//     return pw.Image(pw.PdfImage.file(
//       pwLib.PdfDocument(pdf.document),
//       bytes: imageBytes,
//     ));
//   }
// }
