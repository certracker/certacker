import 'package:certracker/components/home_components/category_container/category_container.dart';
import 'package:certracker/model/category/category_data.dart';
import 'package:certracker/model/category/category_model.dart';
import 'package:flutter/material.dart';

class VaccinationPage extends StatelessWidget {
  const VaccinationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Category> vaccinationCategories = categoryData
        .where((category) => category.category == "Vaccination")
        .toList();

    return ListView(
        padding: const EdgeInsets.all(16),
        children: vaccinationCategories.map((category) {
          return CategoryContainer(
            title: category.title,
            category: category.category,
            imagePath: category.imagePath,
            color: category.color,
          );
        }).toList(),
    );
  }
}
