import 'package:certracker/components/home_components/category_container/category_container.dart';
import 'package:certracker/model/category/category_data.dart';
import 'package:certracker/model/category/category_model.dart';
import 'package:flutter/material.dart';


class TravelPage extends StatelessWidget {
  const TravelPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Category> travelCategories = categoryData
        .where((category) => category.category == "Travel")
        .toList();

    return ListView(
        padding: const EdgeInsets.all(16),
        children: travelCategories.map((category) {
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
