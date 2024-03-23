import 'package:certracker/components/home_components/select_mutilple/data_fetching.dart';
import 'package:certracker/components/home_components/select_mutilple/selete_muiltple.dart';
import 'package:flutter/material.dart';
import 'details_page.dart';

class CategoryContainer extends StatelessWidget {
  final String title;
  final String category;
  final String imagePath;
  final Color color;

  const CategoryContainer({
    super.key,
    required this.title,
    required this.category,
    required this.imagePath,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the details page when container is clicked
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsPage(
              title: title,
              category: category,
              imagePath: imagePath,
              color: color,
            ),
          ),
        );
      },
      onLongPress: () async{
        List<Map<String, dynamic>> userData = await fetchUserData();
        // Navigate to the multiple selection page when long-pressed
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SelectMultiple(
              data: userData // Pass data if required
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
                color: color,
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
                      color: color.withOpacity(0.3), // Background color with opacity
                    ),
                    child: Center(
                      child: Image.asset(
                        imagePath,
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
                          title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          category,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
