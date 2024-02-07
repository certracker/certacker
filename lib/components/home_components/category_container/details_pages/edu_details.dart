import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;

class EducationDetails extends StatelessWidget {
  final Map<String, dynamic> details;

  const EducationDetails({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRow([
              'Credential Name',
            ], [
              details['Title'],
            ]),
            const SizedBox(height: 16.0),
            _buildRow([
              'Degree',
            ], [
              details['educationDegree'],
            ]),
            const SizedBox(height: 16.0),
            _buildRow(
              [
                'Field',
              ],
              [details['educationField']],
            ),
            _buildRow([
              'Graduation Date'
            ], [
              details['graduationDate'],
            ]),
            const SizedBox(height: 16.0),
            _buildFrontImageColumn('Front Image', details['frontImageUrl']),
            const SizedBox(height: 16.0),
            _buildBackImageColumn('Back Image', details['backImageUrl']),
            const SizedBox(height: 16.0),
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
      imageUrl.isNotEmpty
          ? SizedBox(
              width: 400,
              height: 200,
              child: Image.network(
                imageUrl,
                width: 150, // Set the width as per your design
                height: 150, // Set the height as per your design
                fit: BoxFit.cover,
              ),
            )
          : Container(
              width: 400,
              height: 200,
              color: Colors.grey, // Customize the color as needed
              child: const Center(
                child: Text(
                  'No front image uploaded',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
      imageUrl.isNotEmpty
          ? SizedBox(
              width: 400,
              height: 200,
              child: Image.network(
                imageUrl,
                width: 150, // Set the width as per your design
                height: 150, // Set the height as per your design
                fit: BoxFit.cover,
              ),
            )
          : Container(
              width: 400,
              height: 200,
              color: Colors.grey, // Customize the color as needed
              child: const Center(
                child: Text(
                  'No back image uploaded',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
    ],
  );
}


  pw.Widget buildPdfContent(frontImage, backImage) {
    return pw.Column(
      children: [
        _buildPdfRow([
          'Credential Name'
        ], [
          details['Title'],
        ]),
        pw.SizedBox(height: 16.0),
        _buildPdfFrontImageColumn('Front Image', frontImage),
        pw.SizedBox(height: 16.0),
        _buildPdfBackImageColumn('Back Image', backImage),
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

  pw.Widget _buildPdfFrontImageColumn(String title, frontImage) {
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
        pw.Container(
          width: 150,
          height: 150,
          child: pw.Image(frontImage),
        ),
      ],
    );
  }

  pw.Widget _buildPdfBackImageColumn(String title, backImage) {
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
        pw.Container(
          width: 150,
          height: 150,
          child: pw.Image(backImage),
        ),
      ],
    );
  }
}
