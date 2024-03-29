import 'package:certracker/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:certracker/components/home_components/category_container/category_container.dart';
import 'package:flutter/material.dart';

class AllPage extends StatelessWidget {
  const AllPage({super.key});

  @override
  Widget build(BuildContext context) {
    Color defaultCategoryColor = const Color(0xFFF5415F);
    String defaultCategoryImagePath = "assets/images/icons/4.png";

    return FutureBuilder(
      future: fetchUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
          return const Center(
            child: Text(
              "You have not added any credentials",
              style: TextStyle(
                fontSize: 30,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          );
        } else {
          List<Map<String, dynamic>> allCategories = (snapshot.data
              as List<Map<String, dynamic>>)
            ..sort((a, b) =>
                (b['timestamp'] as Timestamp).compareTo(a['timestamp']));

          return ListView(
            padding: const EdgeInsets.all(16),
            children: allCategories.map((credentialsId) {
              String tableName = credentialsId['tableName'];
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

              return CategoryContainer(
                title: credentialsId['Title'],
                category: tableName,
                imagePath: categoryImagePath,
                color: categoryColor,
                expiryDate: credentialsId['ExpiryDate'],
              );
            }).toList(),
          );
        }
      },
    );
  }

  Future<List<Map<String, dynamic>>> fetchUserData() async {
    try {
      String? userId = AuthenticationService().getCurrentUserId();

      if (userId != null) {
        List<QuerySnapshot> snapshots = await Future.wait([
          FirebaseFirestore.instance
              .collection('Certification')
              .where('userId', isEqualTo: userId)
              .get(),
          FirebaseFirestore.instance
              .collection('License')
              .where('userId', isEqualTo: userId)
              .get(),
          FirebaseFirestore.instance
              .collection('Education')
              .where('userId', isEqualTo: userId)
              .get(),
          FirebaseFirestore.instance
              .collection('Vaccination')
              .where('userId', isEqualTo: userId)
              .get(),
          FirebaseFirestore.instance
              .collection('Travel')
              .where('userId', isEqualTo: userId)
              .get(),
          FirebaseFirestore.instance
              .collection('CEU')
              .where('userId', isEqualTo: userId)
              .get(),
          FirebaseFirestore.instance
              .collection('Others')
              .where('userId', isEqualTo: userId)
              .get(),
        ]);
        List<Map<String, dynamic>> userData = [];
        for (QuerySnapshot snapshot in snapshots) {
          userData.addAll(
            snapshot.docs.map((doc) => {
                  ...doc.data() as Map<String, dynamic>,
                  'tableName': doc.reference.parent.id,
                  'timestamp': doc['timestamp'],
                }),
          );
        }
        return userData;
      } else {
        throw Exception('User not authenticated!');
      }
    } catch (e) {
      print('Error fetching user data: $e');
      rethrow;
    }
  }
}
