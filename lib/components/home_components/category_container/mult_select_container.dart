import 'package:flutter/material.dart';

import 'details_page.dart';
// import 'details_page.dart';
class MultipleCategoryContainer extends StatefulWidget {
  final String title;
  final String category;
  final String imagePath;
  final Color color;
  final bool isSelected;
  final void Function(bool?)? onSelectChanged; // Corrected definition

  const MultipleCategoryContainer({
    super.key,
    required this.title,
    required this.category,
    required this.imagePath,
    required this.color,
    required this.isSelected,
    required this.onSelectChanged, // Corrected parameter type
  });

  @override
  State<MultipleCategoryContainer> createState() =>
      _MultipleCategoryContainerState();
}

class _MultipleCategoryContainerState extends State<MultipleCategoryContainer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the details page when container is clicked
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsPage(
              title: widget.title,
              category: widget.category,
              imagePath: widget.imagePath,
              color: widget.color,
              
            ),
          ),
        );
      },
      child: Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            width: 4,
            child: Container(
              color: widget.color,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color.withOpacity(0.3),
                  ),
                  child: Center(
                    child: Image.asset(
                      widget.imagePath,
                      width: 30,
                      height: 30,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.category,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Checkbox(
                  value: widget.isSelected,
                  onChanged: widget.onSelectChanged,
                ),
              ],
            ),
          ),
        ],
      ),
    )
    );
  }
}
