import 'package:flutter/material.dart';

class CertificationDetails extends StatelessWidget {
  final Map<String, dynamic> details;

  const CertificationDetails({Key? key, required this.details}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: buildFieldColumn('Credential Name', details['Title'])),
            Expanded(child: buildFieldColumn('Credential Record Number', details['certificationNumber'])),
            Expanded(child: buildFieldColumn('Field3', details['Field3'])),
          ],
        ),
        SizedBox(height: 16.0),
        Row(
          children: [
            Expanded(child: buildFieldColumn('Field4', details['Field4'])),
            Expanded(child: buildFieldColumn('Field5', details['Field5'])),
            Expanded(child: buildFieldColumn('Field6', details['Field6'])),
          ],
        ),
      ],
    );
  }

  Widget buildFieldColumn(String fieldName, dynamic value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          fieldName, // Field name
          style: const TextStyle(
            fontSize: 14.0,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          value.toString(), // Field value
           style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}
