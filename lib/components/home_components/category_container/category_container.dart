// import 'package:certracker/components/home_components/select_mutilple/data_fetching.dart';
import 'package:certracker/components/home_components/select_mutilple/data_page.dart';
import 'package:certracker/components/home_components/select_mutilple/selete_muiltple.dart';
import 'package:flutter/material.dart';
import 'details_page.dart';

class CategoryContainer extends StatelessWidget {
  final String title;
  final String category;
  final String imagePath;
  final Color color;
  final String? expiryDate;

  const CategoryContainer({
    super.key,
    required this.title,
    required this.category,
    required this.imagePath,
    required this.color,
    this.expiryDate,
  });

  int calculateRemainingDays(DateTime expiryDate) {
    final now = DateTime.now();
    final difference = expiryDate.difference(now).inDays;
    return difference;
  }

  @override
  Widget build(BuildContext context) {
    final expiryDateTime =
        expiryDate != null ? DateTime.parse(expiryDate!) : null;
    final remainingDays =
        expiryDateTime != null ? calculateRemainingDays(expiryDateTime) : null;

    bool isExpired =
        expiryDateTime != null && expiryDateTime.isBefore(DateTime.now());

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
      onLongPress: () {
        // Show loading indicator
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        );

        // Fetch user data asynchronously
        fetchUserDataWithPdf().then((userData) {
          // Close loading indicator
          Navigator.of(context).pop();

          // Navigate to the multiple selection page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SelectMultiple(
                data: userData, // Pass data if required
              ),
            ),
          );
        }).catchError((error) {
          // Handle error if data fetching fails
          Navigator.of(context).pop(); // Close loading indicator
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to fetch user data: $error'),
            ),
          );
        });
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
                      color: color
                          .withOpacity(0.3), // Background color with opacity
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
            Positioned(
              top: 0,
              right: 0,
              child: expiryDate != null
                  ? Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        color: isExpired
                            ? Colors.red
                            : Colors.transparent, // Change background color
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            isExpired
                                ? 'Expired'
                                : 'Expiries in $remainingDays' ' days',
                            style: TextStyle(
                              color: isExpired
                                  ? Colors.white
                                  : Colors.black, // Change text color
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
