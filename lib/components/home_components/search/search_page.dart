import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:certracker/auth/auth_service.dart';
import 'package:certracker/components/home_components/category_container/category_container.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Page', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0XFF591A8F),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search by title...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Color(0XFF591A8F)),
                  ),
                ),
                onChanged: _performSearch,
              ),
              if (isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: CircularProgressIndicator(),
                )
              else if (searchResults.isNotEmpty)
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    children: searchResults.map((credentialsId) {
                      String tableName = credentialsId['tableName'];
                      Color categoryColor = _getDefaultColor(tableName);
                      String categoryImagePath =
                          _getDefaultImagePath(tableName);

                      return CategoryContainer(
                        title: credentialsId['Title'],
                        category: tableName,
                        imagePath: categoryImagePath,
                        color: categoryColor,
                      );
                    }).toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        searchResults.clear();
      });
      return;
    }

    fetchSearchData(query.toLowerCase());
  }

  Future<void> fetchSearchData(String query) async {
    try {
      setState(() {
        isLoading = true;
      });

      String? userId = AuthenticationService().getCurrentUserId();

      if (userId != null) {
        List<QuerySnapshot> snapshots = await Future.wait([
          FirebaseFirestore.instance
              .collection('Certification')
              .where('userId', isEqualTo: userId)
              .orderBy('Title', descending: false)
              .startAt([query]).endAt(['$query\uf8ff']).get(),
          FirebaseFirestore.instance
              .collection('License')
              .where('userId', isEqualTo: userId)
              .orderBy('Title', descending: false)
              .startAt([query]).endAt(['$query\uf8ff']).get(),
          FirebaseFirestore.instance
              .collection('Education')
              .where('userId', isEqualTo: userId)
              .orderBy('Title', descending: false)
              .startAt([query]).endAt(['$query\uf8ff']).get(),
          FirebaseFirestore.instance
              .collection('Vaccination')
              .where('userId', isEqualTo: userId)
              .orderBy('Title', descending: false)
              .startAt([query]).endAt(['$query\uf8ff']).get(),
          FirebaseFirestore.instance
              .collection('Travel')
              .where('userId', isEqualTo: userId)
              .orderBy('Title', descending: false)
              .startAt([query]).endAt(['$query\uf8ff']).get(),
          FirebaseFirestore.instance
              .collection('CEU')
              .where('userId', isEqualTo: userId)
              .orderBy('Title', descending: false)
              .startAt([query]).endAt(['$query\uf8ff']).get(),
          FirebaseFirestore.instance
              .collection('Others')
              .where('userId', isEqualTo: userId)
              .orderBy('Title', descending: false)
              .startAt([query]).endAt(['$query\uf8ff']).get(),
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

        setState(() {
          searchResults = userData;
          isLoading = false;
        });
      } else {
        throw Exception('User not authenticated!');
      }
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        isLoading = false;
      });
      rethrow;
    }
  }

  Color _getDefaultColor(String tableName) {
    switch (tableName) {
      case 'Certification':
        return const Color(0xFF8A6C0A);
      case 'License':
        return const Color(0xFF591A8F);
      case 'Education':
        return const Color(0xFF0A8A17);
      case 'Vaccination':
        return const Color(0xFFF5415F);
      case 'Travel':
        return const Color(0xFF61B7F6);
      case 'CEU':
        return const Color(0xFF789D1C);
      case 'Others':
        return const Color(0xFF691B27);
      default:
        return const Color(0xFFF5415F); // Default color
    }
  }

  String _getDefaultImagePath(String tableName) {
    switch (tableName) {
      case 'Certification':
        return "assets/images/icons/1.png";
      case 'License':
        return "assets/images/icons/2.png";
      case 'Education':
        return "assets/images/icons/3.png";
      case 'Vaccination':
        return "assets/images/icons/4.png";
      case 'Travel':
        return "assets/images/icons/5.png";
      case 'CEU':
        return "assets/images/icons/6.png";
      case 'Others':
        return "assets/images/icons/7.png";
      default:
        return "assets/images/icons/4.png";
    }
  }
}