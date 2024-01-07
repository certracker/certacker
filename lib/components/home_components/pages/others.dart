import 'package:certracker/components/home_components/category_container/category_container.dart';
import 'package:certracker/model/category/category_data.dart';
import 'package:certracker/model/category/category_model.dart';
import 'package:flutter/material.dart';


class OthersPage extends StatelessWidget {
  const OthersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Category> othersCategories = categoryData
        .where((category) => category.category == "Others")
        .toList();

    return ListView(
        padding: const EdgeInsets.all(16),
        children: othersCategories.map((category) {
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
