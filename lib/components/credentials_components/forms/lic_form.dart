import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddLicensePage extends StatefulWidget {
  const AddLicensePage({Key? key}) : super(key: key);

  @override
  State<AddLicensePage> createState() => _AddLicensePageState();
}

class _AddLicensePageState extends State<AddLicensePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _certificationNameController =
      TextEditingController();
  final TextEditingController _recordNumberController = TextEditingController();
  final TextEditingController _issueDateController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _privateNoteController = TextEditingController();

  Future<void> getImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // Image selected from gallery - Perform operations here
    }
  }

  Future<void> getDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc'], // Add allowed document formats here
    );

    if (result != null) {
      // Document selected - Perform operations here
      // You can access the picked document using result.files.first
    }
  }

  @override
  void dispose() {
    _certificationNameController.dispose();
    _recordNumberController.dispose();
    _issueDateController.dispose();
    _expiryDateController.dispose();
    _privateNoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add License"),
        centerTitle: true,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  "License Information",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _certificationNameController,
                  decoration: const InputDecoration(
                    labelText: "License Type*",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Select License Type*";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _issueDateController,
                  decoration: const InputDecoration(
                    labelText: "License Number*",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter License Number";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _expiryDateController,
                  decoration: const InputDecoration(
                    labelText: "Issue Date*",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter Date Issue";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _expiryDateController,
                  decoration: const InputDecoration(
                    labelText: "Expiry Date*",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter Expiry Date";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _expiryDateController,
                  decoration: const InputDecoration(
                    labelText: "State*",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter State";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "First Reminder",
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Second Reminder",
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Final Reminder",
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Upload Photo",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Front",
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    getImageFromGallery();
                  },
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 200,
                      width: 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[200],
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.upload, size: 50),
                          SizedBox(height: 10),
                          Text(
                            "Upload Photo",
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Supported formats: JPEG, PNG, JPG",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  "Back",
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    getImageFromGallery();
                  },
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 200,
                      width: 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[200],
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.upload, size: 50),
                          SizedBox(height: 10),
                          Text(
                            "Upload Photo",
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Supported formats: JPEG, PNG, JPG",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  "File",
                ),
                const SizedBox(height: 20),
                const Text(
                  "Attach a file format of this credential",
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
                GestureDetector(
                  onTap: () {
                    getDocument();
                  },
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 200,
                      width: 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[200],
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.upload, size: 50),
                          SizedBox(height: 10),
                          Text(
                            "Upload Files",
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Supported format: DOC, PDF",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Private Note",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Want to say something about this credential?",
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _privateNoteController,
                  keyboardType: TextInputType.multiline,
                  minLines: 5, // Adjust this value to increase the height
                  maxLines: null,
                  decoration: const InputDecoration(
                    // labelText: "Add your note here",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      // Process form data
                      // You can access form field values here
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 112),
                    decoration: BoxDecoration(
                      color: const Color(0xFF39115B),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "Save Certification",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
