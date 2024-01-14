import 'package:flutter/material.dart';

class LicenseDetails extends StatelessWidget {
  final Map<String, dynamic> details;

  const LicenseDetails({Key? key, required this.details}) : super(key: key);

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
                Expanded(child: buildFieldColumn('license Number', details['licenseNumber'])),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(child: buildFieldColumn('First Reminder', details['licenseFirstReminder'])),
                Expanded(child: buildFieldColumn('Second Reminder', details['licenseSecondReminder'])),
                Expanded(child: buildFieldColumn('Final Reminder', details['licenseFinalReminder'])),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(child: buildFieldColumn('State', details['licenseState'])),
                Expanded(child: buildFieldColumn('Issue Date', details['licenseIssueDate'])),
                Expanded(child: buildFieldColumn('Expiry Date', details['licenseExpiryDate'])),
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
                    width: 150, 
                    height: 150,
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
                    width: 150, 
                    height: 150,
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
