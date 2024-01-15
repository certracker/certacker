import 'package:flutter/material.dart';

class OthersDetails extends StatelessWidget {
  final Map<String, dynamic> details;

  const OthersDetails({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: buildFieldColumn('Credential Name', details['Title'])),
                Expanded(child: buildFieldColumn('Credential Record Number', details['otherNumber'])),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(child: buildFieldColumn('First Reminder', details['otherFirstReminder'])),
                Expanded(child: buildFieldColumn('Second Reminder', details['otherSecondReminder'])),
                Expanded(child: buildFieldColumn('Final Reminder', details['otherFinalReminder'])),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(child: buildFieldColumn('Issue Date', details['otherIssueDate'])),
                Expanded(child: buildFieldColumn('Expiry Date', details['otherExpiryDate'])),
                // Add another Expanded for the second reminder if needed
              ],
            ),
            const SizedBox(height: 16.0),
            Column(
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
                    details['frontImageUrl'],
                    width: 150, // Set the width as per your design
                    height: 150, // Set the height as per your design
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Column(
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
                    details['backImageUrl'],
                    width: 150, // Set the width as per your design
                    height: 150, // Set the height as per your design
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
