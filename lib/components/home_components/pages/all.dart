import 'package:certracker/components/home_components/category_container/category_container.dart';
import 'package:certracker/model/category/category_data.dart';
import 'package:flutter/material.dart';


class AllPage extends StatelessWidget {
  const AllPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
        padding: const EdgeInsets.all(16),
        children: categoryData.map((category) {
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

