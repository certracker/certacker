import 'package:flutter/material.dart';

class VaccinationForm extends StatelessWidget {
  final TextEditingController vaccinationNameController = TextEditingController();
  final TextEditingController vaccineTypeController = TextEditingController();
  final TextEditingController dateAdministeredController = TextEditingController();
  final TextEditingController nextDoseDateController = TextEditingController();
  final TextEditingController photoController = TextEditingController();
  final TextEditingController privateNoteController = TextEditingController();

  VaccinationForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: vaccinationNameController,
            decoration: const InputDecoration(
              labelText: 'Vaccination Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: vaccineTypeController,
            decoration: const InputDecoration(
              labelText: 'Vaccine Type',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: privateNoteController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Private Note',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
