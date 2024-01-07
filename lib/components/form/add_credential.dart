import 'package:certracker/components/colors/app_colors.dart';
import 'package:certracker/components/form/certification_form.dart';
import 'package:certracker/components/form/ceu_form.dart';
import 'package:certracker/components/form/education_form.dart';
import 'package:certracker/components/form/license_form.dart';
import 'package:certracker/components/form/others_form.dart';
import 'package:certracker/components/form/travel_form.dart';
import 'package:certracker/components/form/vaccination_form.dart';
import 'package:certracker/model/category/category_data.dart';
import 'package:certracker/model/category/category_model.dart';
import 'package:flutter/material.dart';

class AddCredentialPage extends StatefulWidget {
  const AddCredentialPage({Key? key}) : super(key: key);

  @override
  State<AddCredentialPage> createState() => _AddCredentialPageState();
}

class _AddCredentialPageState extends State<AddCredentialPage> {
  String selectedCategory = '';
  final TextEditingController titleController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();

  Widget renderFormByCategory(String category) {
    switch (category) {
      case 'Certification':
        return CertificationForm();
      case 'License':
        return LicenseForm();
      case 'Education':
        return EducationForm();
      case 'Vaccination':
        return VaccinationForm();
      case 'Travel':
        return TravelForm();
      case 'CEU/CME':
        return CEUForm();
      case 'Others':
        return OthersForm();
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Credential",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent, // Set the background color to transparent
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [CustomColors.gradientStart, CustomColors.gradientEnd],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: selectedCategory.isNotEmpty ? selectedCategory : null,
                hint: const Text('Select a category'),
                items: categoryData.map((Category category) {
                  return DropdownMenuItem<String>(
                    value: category.category,
                    child: Row(
                      children: [
                        Image.asset(
                          category.imagePath,
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(category.category),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    selectedCategory = value ?? '';
                  });
                },
              ),
              const SizedBox(height: 20),
              if (selectedCategory.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    renderFormByCategory(selectedCategory),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
