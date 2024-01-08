import 'package:flutter/material.dart';

class TravelForm extends StatefulWidget {
  const TravelForm({Key? key}) : super(key: key);

  @override
  State<TravelForm> createState() => _TravelFormState();
}

class _TravelFormState extends State<TravelForm> {
  final TextEditingController travelCountryController = TextEditingController();
  final TextEditingController travelPlaceOfIssueController =
      TextEditingController();
  final TextEditingController travelDocumentNumberController =
      TextEditingController();
  final TextEditingController travelIssueDateController =
      TextEditingController();
  final TextEditingController travelExpiryDateController =
      TextEditingController();
  final TextEditingController travelPrivateNoteController =
      TextEditingController();

  String documentType = 'Passport'; // Default value

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Credential Information",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Text("Document Type: ",
                style: TextStyle(fontSize: 16)),
            Radio<String>(
              value: "Passport",
              groupValue: documentType,
              onChanged: (value) {
                setState(() {
                  documentType = value!;
                });
              },
            ),
            const Text("Passport",
                style: TextStyle(fontSize: 14,)),
            Radio<String>(
              value: "Driver’s License",
              groupValue: documentType,
              onChanged: (value) {
                setState(() {
                  documentType = value!;
                });
              },
            ),
            const Text("Driver’s License",
                style: TextStyle(fontSize: 14,)),
          ],
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: travelCountryController,
          decoration: const InputDecoration(
            labelText: "Country",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: travelPlaceOfIssueController,
          decoration: const InputDecoration(
            labelText: "Place of issue",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: travelDocumentNumberController,
          decoration: InputDecoration(
            labelText: documentType == 'Passport'
                ? "Passport Number"
                : "Driver’s License Number",
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: travelIssueDateController,
          decoration: const InputDecoration(
            labelText: "Issue Date",
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.calendar_today),
          ),
          readOnly: true,
          onTap: () async {
            final DateTime? selectedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (selectedDate != null) {
              travelIssueDateController.text =
                  selectedDate.toLocal().toString().split(' ')[0];
            }
          },
        ),
        const SizedBox(height: 42),
        TextFormField(
          controller: travelExpiryDateController,
          decoration: const InputDecoration(
            labelText: "Expiration Date",
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.calendar_today),
          ),
          readOnly: true,
          onTap: () async {
            final DateTime? selectedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (selectedDate != null) {
              travelExpiryDateController.text =
                  selectedDate.toLocal().toString().split(' ')[0];
            }
          },
        ),
        const SizedBox(height: 42),
        const Text(
          "Upload Photo",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "Front",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: 400,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.camera_alt, size: 40),
              SizedBox(height: 8),
              Text(
                "Add image",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Supported formats: JPEG, PNG, JPG",
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "Back",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: 400,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.camera_alt, size: 40),
              SizedBox(height: 8),
              Text(
                "Add image",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Supported formats: JPEG, PNG, JPG",
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(height: 42),
        const Text(
          "Private Note",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "Want to say something about this credential?",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: travelPrivateNoteController,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: 'Type here...',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: () {
              // Your button logic
            },
            child: Container(
              width: 400,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFF39115B),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(10),
              child: const Text(
                "Save Credential",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
