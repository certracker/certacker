import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class CertificationDetails extends StatelessWidget {
  final Map<String, dynamic> details;

  const CertificationDetails({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRow(['Credential Name'], [details['Title']]),
              const SizedBox(height: 16.0),
              _buildRow(['Credential Record Number'], [details['Number']]),
              const SizedBox(height: 16.0),
              _buildRow(['Issue Date'], [details['IssueDate']]),
              const SizedBox(height: 16.0),
              _buildRow(['Expiry Date'], [details['ExpiryDate']]),
              const SizedBox(height: 16.0),
              if (details.containsKey('pdfPath'))
                _buildPDFView(context, details['pdfPath']),
              const SizedBox(height: 16.0),
              _buildRow(['Note'], [details['PrivateNote']]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(List<String> leftFields, List<dynamic> leftValues) {
    return Row(
      children: [
        Expanded(child: _buildFieldColumn(leftFields, leftValues)),
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

  Widget _buildPDFView(BuildContext context, String pdfPath) {
    return SizedBox(
      height: 400, // Set a fixed height for the PDF view
      child: PDFView(
        filePath: pdfPath,
      ),
    );
  }
}
