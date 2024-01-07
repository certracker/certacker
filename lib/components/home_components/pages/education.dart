import 'package:certracker/components/home_components/category_container/category_container.dart';
import 'package:certracker/model/category/category_data.dart';
import 'package:certracker/model/category/category_model.dart';
import 'package:flutter/material.dart';

class EducationPage extends StatelessWidget {
  const EducationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Category> educationCategories = categoryData
        .where((category) => category.category == "Education")
        .toList();

    return ListView(
        padding: const EdgeInsets.all(16),
        children: educationCategories.map((category) {
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
