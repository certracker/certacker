import 'package:flutter/material.dart';

class OthersForm extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController photoController = TextEditingController();
  final TextEditingController privateNoteController = TextEditingController();

  OthersForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: categoryController,
            decoration: const InputDecoration(
              labelText: 'Category',
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
