import 'package:flutter/material.dart';

class CEUDetails extends StatelessWidget {
  final Map<String, dynamic> details;

  const CEUDetails({super.key, required this.details});

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
                Expanded(child: buildFieldColumn('Provider Name', details['ceuProviderName'])),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(child: buildFieldColumn('Number Of Contact Hour', details['ceuNumberOfContactHour'])),
                Expanded(child: buildFieldColumn('Completion Date', details['ceuCompletionDate'])),
                Expanded(child: buildFieldColumn('Final Reminder', details['certificationFinalReminder'])),
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
