import 'package:flutter/material.dart';
import 'package:certracker/components/home_components/category_container/category_container.dart';

class SearchPage extends StatefulWidget {
  final List<Map<String, dynamic>> userData;

  const SearchPage({super.key, required this.userData});

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

    // Perform search in already fetched data
    List<Map<String, dynamic>> results = [];
    for (Map<String, dynamic> userData in widget.userData) {
      if (userData['Title'].toLowerCase().contains(query.toLowerCase())) {
        results.add(userData);
      }
    }

    setState(() {
      searchResults = results;
    });
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
