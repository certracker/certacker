import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;

class CertificationDetails extends StatelessWidget {
  final Map<String, dynamic> details;

  const CertificationDetails({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRow(['Credential Name', details['Title']],
                ['Credential Record Number', details['certificationNumber']]),
            const SizedBox(height: 16.0),
            _buildRow(
              ['First Reminder', details['certificationFirstReminder']],
              ['Second Reminder', details['certificationSecondReminder']],
              ['Final Reminder', details['certificationFinalReminder']],
            ),
            const SizedBox(height: 16.0),
            _buildRow(['Issue Date', details['certificationIssueDate']],
                ['Expiry Date', details['certificationExpiryDate']]),
            const SizedBox(height: 16.0),
            _buildFrontImageColumn('Front Image', details['frontImageUrl']),
            const SizedBox(height: 16.0),
            _buildBackImageColumn('Back Image', details['backImageUrl']),
            const SizedBox(height: 16.0),
            // ElevatedButton(
            //   onPressed: () => _sharePdf(context),
            //   child: const Text('Share as PDF'),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(List<String> leftFields, List<dynamic> leftValues,
      [List<String>? rightFields, List<dynamic>? rightValues]) {
    return Row(
      children: [
        Expanded(child: _buildFieldColumn(leftFields, leftValues)),
        if (rightFields != null && rightValues != null)
          Expanded(child: _buildFieldColumn(rightFields, rightValues)),
      ],
    );
  }

  Widget _buildFieldColumn(List<String> fields, List<dynamic> values) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(fields.length, (index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fields[index], // Field name
              style: const TextStyle(
                fontSize: 14.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              values[index].toString(), // Field value
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
          ],
        );
      }),
    );
  }

  Widget _buildFrontImageColumn(String title, String imageUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Front Image',
          style: TextStyle(
            fontSize: 14.0,
          ),
        ),
        const SizedBox(height: 8.0),
        SizedBox(
          width: 400,
          height: 200,
          child: Image.network(
            imageUrl,
            width: 150, // Set the width as per your design
            height: 150, // Set the height as per your design
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }

  Widget _buildBackImageColumn(String title, String imageUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Back Image',
          style: TextStyle(
            fontSize: 14.0,
          ),
        ),
        const SizedBox(height: 8.0),
        SizedBox(
          width: 400,
          height: 200,
          child: Image.network(
            imageUrl,
            width: 150, // Set the width as per your design
            height: 150, // Set the height as per your design
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }

  Future<void> _downloadAndSaveImage(String imageUrl, String fileName) async {
    final response = await http.get(Uri.parse(imageUrl));
    final bytes = response.bodyBytes;
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$fileName');
    await file.writeAsBytes(bytes);
  }

  Future<String> _getLocalImagePath(String imageUrl) async {
    final fileName = imageUrl.split('/').last;
    final localPath = '${(await getTemporaryDirectory()).path}/$fileName';

    if (!File(localPath).existsSync()) {
      await _downloadAndSaveImage(imageUrl, fileName);
    }

    return localPath;
  }

  Future<void> _sharePdf(BuildContext context) async {
    // Create PDF document
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => buildPdfContent(),
      ),
    );

    // Save PDF to a temporary file
    final tempPath = (await getTemporaryDirectory()).path;
    final pdfFile = File('$tempPath/certification_details.pdf');
    await pdfFile.writeAsBytes(await pdf.save());

    // Share the PDF file
    await Share.shareFiles(['$tempPath/certification_details.pdf'],
        text: 'Certification Details PDF');
  }

  pw.Widget buildPdfContent() {
    return pw.Column(
      children: [
        _buildPdfRow(['Credential Name', details['Title']],
            ['Credential Record Number', details['certificationNumber']]),
        pw.SizedBox(height: 16.0),
        _buildPdfRow(
          ['First Reminder', details['certificationFirstReminder']],
          ['Second Reminder', details['certificationSecondReminder']],
          ['Final Reminder', details['certificationFinalReminder']],
        ),
        pw.SizedBox(height: 16.0),
        _buildPdfRow(['Issue Date', details['certificationIssueDate']],
            ['Expiry Date', details['certificationExpiryDate']]),
        pw.SizedBox(height: 16.0),
        _buildPdfFontImageColumn('Front Image', details['frontImageUrl']),
        pw.SizedBox(height: 16.0),
        _buildPdfBackImageColumn('Back Image', details['backImageUrl']),
      ],
    );
  }

  pw.Widget _buildPdfRow(List<String> leftFields, List<dynamic> leftValues,
      [List<String>? rightFields, List<dynamic>? rightValues]) {
    return pw.Row(
      children: [
        pw.Expanded(child: _buildPdfFieldColumn(leftFields, leftValues)),
        if (rightFields != null && rightValues != null)
          pw.Expanded(child: _buildPdfFieldColumn(rightFields, rightValues)),
      ],
    );
  }

  pw.Widget _buildPdfFieldColumn(List<String> fields, List<dynamic> values) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: List.generate(fields.length, (index) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              fields[index], // Field name
              style: const pw.TextStyle(
                fontSize: 14.0,
              ),
            ),
            pw.SizedBox(height: 8.0),
            pw.Text(
              values[index].toString(), // Field value
              style: pw.TextStyle(
                fontSize: 16.0,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 16.0),
          ],
        );
      }),
    );
  }

  pw.Widget _buildPdfFontImageColumn(String title, String imageUrl) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: const pw.TextStyle(
            fontSize: 14.0,
          ),
        ),
        pw.SizedBox(height: 8.0),
        // pw.Container(
        //   width: 150,
        //   height: 150,
        //   child: pw.Image(pw.NetworkImage(imageUrl)),
        // ),
      ],
    );
  }

  pw.Widget _buildPdfBackImageColumn(String title, String imageUrl) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: const pw.TextStyle(
            fontSize: 14.0,
          ),
        ),
        pw.SizedBox(height: 8.0),
        // pw.Container(
        //   width: 150,
        //   height: 150,
        //   child: pw.Image(pw.NetworkImage(imageUrl)),
        // ),
      ],
    );
  }
}
