import 'package:certracker/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:certracker/components/home_components/category_container/category_container.dart';
import 'package:flutter/material.dart';

class VaccinationPage extends StatelessWidget {
  const VaccinationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define color and imagePath variables
    Color categoryColor =
        const Color(0xFFF5415F); // Change to the desired color
    String categoryImagePath =
        "assets/images/icons/4.png"; // Change to the desired image path

    return FutureBuilder(
      future: fetchVaccinationData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // If still loading data, show a loading indicator
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          // If there's an error, show an error message
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
          // If there's no data, show a message indicating no Vaccination data
          return const Center(
            child:  Text('No Vaccination data available'),
          );
        } else {
          // If data is available, build the UI using CategoryContainer
          List<Map<String, dynamic>> vaccinationCategories =
              snapshot.data as List<Map<String, dynamic>>;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: vaccinationCategories.map((credentialsId) {
              return CategoryContainer(
                title: credentialsId['Title'],
                category: "Vaccination",
                imagePath: categoryImagePath,
                color: categoryColor,
              );
            }).toList(),
          );
        }
      },
    );
  }

  Future<List<Map<String, dynamic>>> fetchVaccinationData() async {
    try {
      // Get the current user's ID
      String? userId = AuthenticationService().getCurrentUserId();

      if (userId != null) {
        // Fetch Vaccination data for the current user from Firestore
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('Vaccination')
            .where('userId', isEqualTo: userId)
            .get();

        // Convert the query snapshot into a list of Map<String, dynamic>
        return querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      } else {
        // Handle if the user ID is null (user not authenticated)
        throw Exception('User not authenticated!');
      }
    } catch (e) {
      // Handle errors
      print('Error fetching Vaccination data: $e');
      rethrow;
    }
  }
}
