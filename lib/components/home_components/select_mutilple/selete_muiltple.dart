import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:certracker/components/home_components/category_container/mult_select_container.dart';

import 'function.dart';
import 'multiple_bottom_nav.dart'; // Import DeleteDataService here

class SelectMultiple extends StatefulWidget {
  final List<Map<String, dynamic>> data;

  const SelectMultiple({super.key, required this.data});

  @override
  State<SelectMultiple> createState() => _SelectMultipleState();
}

class _SelectMultipleState extends State<SelectMultiple> {
  late List<Map<String, dynamic>> _selectedItems;

  @override
  void initState() {
    super.initState();
    _selectedItems = [];
  }

  @override
  Widget build(BuildContext context) {
    Color defaultCategoryColor = const Color(0xFFF5415F);
    String defaultCategoryImagePath = "assets/images/icons/4.png";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Multiple Selection', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0XFF591A8F),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: widget.data.map((item) {
          String tableName = item['tableName'];
          Color categoryColor = defaultCategoryColor;
          String categoryImagePath = defaultCategoryImagePath;
          switch (tableName) {
            case 'Certification':
              categoryColor = const Color(0xFF8A6C0A);
              categoryImagePath = "assets/images/icons/1.png";
              break;
            case 'License':
              categoryColor = const Color(0xFF591A8F);
              categoryImagePath = "assets/images/icons/2.png";
              break;
            case 'Education':
              categoryColor = const Color(0xFF0A8A17);
              categoryImagePath = "assets/images/icons/3.png";
              break;
            case 'Vaccination':
              categoryColor = const Color(0xFFF5415F);
              categoryImagePath = "assets/images/icons/4.png";
              break;
            case 'Travel':
              categoryColor = const Color(0xFF61B7F6);
              categoryImagePath = "assets/images/icons/5.png";
              break;
            case 'CEU':
              categoryColor = const Color(0xFF789D1C);
              categoryImagePath = "assets/images/icons/6.png";
              break;
            case 'Others':
              categoryColor = const Color(0xFF691B27);
              categoryImagePath = "assets/images/icons/7.png";
              break;
            default:
          }

          bool isSelected = _selectedItems.contains(item);

          return ListTile(
            title: MultipleCategoryContainer(
              title: item['Title'],
              category: tableName,
              imagePath: categoryImagePath,
              color: categoryColor,
              isSelected: isSelected,
              onSelectChanged: (value) {
                setState(() {
                  if (value != null && value) {
                    _selectedItems.add(item);
                    if (kDebugMode) {
                      print('Selected item: $item');
                    }
                  } else {
                    _selectedItems.remove(item);
                  }
                });
              },
            ),
          );
        }).toList(),
      ),
      bottomNavigationBar: BottomNavBar(
        onSharePressed: () {
          // Share selected PDF files
          shareSelectedPDFs(_selectedItems);
        },
        onDeletePressed: () {
          // Delete selected data
          DeleteDataService.deleteSelectedData(
              _selectedItems); // Call the deleteSelectedData function
        },
        onCancelPressed: () {
          // Add your cancel functionality here
          print('Cancel pressed');
        },
      ),
    );
  }
}
