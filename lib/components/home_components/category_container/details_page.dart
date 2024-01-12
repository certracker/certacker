import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailsPage extends StatefulWidget {
  final String title;
  final String category;
  final String imagePath;
  final Color color;

  const DetailsPage({
    Key? key,
    required this.title,
    required this.category,
    required this.imagePath,
    required this.color,
  }) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late Future<Map<String, dynamic>> fetchData;

  @override
  void initState() {
    super.initState();
    fetchData = fetchDetails();
  }

  Future<Map<String, dynamic>> fetchDetails() async {
    try {
      String collectionName = getCategoryCollectionName(widget.category);

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(collectionName)
          .where('Title', isEqualTo: widget.title)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic> details =
            querySnapshot.docs.first.data() as Map<String, dynamic>;

        // Exclude 'userId' and 'timestamp' fields
        details.remove('userId');
        details.remove('timestamp');

        return details;
      } else {
        throw Exception('Details not found!');
      }
    } catch (e) {
      print('Error fetching details: $e');
      rethrow;
    }
  }

  String getCategoryCollectionName(String category) {
    Map<String, String> categoryCollectionMap = {
      'Certification': 'Certification',
      'License': 'License',
      'Education': 'Education',
      'Vaccination': 'Vaccination',
      'Travel': 'Travel',
      'CEU/CME': 'CEU',
      'Others': 'Others',
    };

    return categoryCollectionMap[category] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppBar(
              automaticallyImplyLeading: false,
              flexibleSpace: SizedBox(
                height: 170,
                child: Stack(
                  children: [
                    Image.asset(
                      widget.imagePath,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      color: widget.color.withOpacity(0.7),
                    ),
                    Positioned(
                      top: 16.0,
                      left: 16.0,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        color: Colors.white, // Set arrow back icon color to white
                      ),
                    ),
                    Positioned(
                      top: 16.0,
                      right: 16.0,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              // Handle edit action
                            },
                            color: Colors.white, // Set edit icon color to white
                          ),
                          IconButton(
                            icon: const Icon(Icons.share),
                            onPressed: () {
                              // Handle share action
                            },
                            color: Colors.white, // Set share icon color to white
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              // Handle delete action
                            },
                            color: Colors.white, // Set delete icon color to white
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 16.0,
                      left: 16.0,
                      right: 16.0,
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              widget.title,
                              style: const TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              widget.category,
                              style: const TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: fetchData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return const Center(child: Text('Details not available.'));
                  } else {
                    Map<String, dynamic> details =
                        snapshot.data as Map<String, dynamic>;

                    return Column(
                      children: [
                        Text('Details: ${details.toString()}'),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
