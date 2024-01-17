import 'package:flutter/material.dart';

class EditCEUPage extends StatefulWidget {
  final Map<String, dynamic> initialDetails;

  const EditCEUPage({super.key, required this.initialDetails});

  @override
  State<EditCEUPage> createState() => _EditCEUPageState();
}

class _EditCEUPageState extends State<EditCEUPage> {
  late TextEditingController _titleController;
  late TextEditingController _providerNameController;
  late TextEditingController _numberOfContactHourController;
  late TextEditingController _completionDateController;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.initialDetails['Title']);
    _providerNameController =
        TextEditingController(text: widget.initialDetails['ceuProviderName']);
    _numberOfContactHourController = TextEditingController(
        text: widget.initialDetails['ceuNumberOfContactHour']);
    _completionDateController =
        TextEditingController(text: widget.initialDetails['ceuCompletionDate']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit CEU'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextField('Credential Name', _titleController),
              buildTextField('Provider Name', _providerNameController),
              const SizedBox(height: 16.0),
              buildTextField(
                  'Number Of Contact Hour', _numberOfContactHourController),
              buildTextField('Completion Date', _completionDateController),
              const SizedBox(height: 16.0),
              // Add Image pickers or editing options here if needed
              ElevatedButton(
                onPressed: () {
                  // Save the edited data to the database
                  // You can use the _titleController.text, _providerNameController.text, etc. to get the edited values
                  // Perform the database update logic here
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
            fontSize: 14.0,
          ),
        ),
        const SizedBox(height: 8.0),
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}
