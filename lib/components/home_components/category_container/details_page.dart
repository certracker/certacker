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
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  // Define variables to store details fetched from Firestore
  String detailsTitle = "";
  String detailsDescription = "";

  @override
  void initState() {
    super.initState();
    // Fetch details from Firestore when the page is initialized
    fetchDetailsFromFirestore();
  }

  Future<void> fetchDetailsFromFirestore() async {
    try {
      // Replace 'your_collection_name' with the actual Firestore collection name
      String collectionName = ''; // Add your Firestore collection name
      String titleField = 'Title';
      String descriptionField = 'Description';

      // Fetch details based on the clicked container's title
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(collectionName)
          .where(titleField, isEqualTo: widget.title)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document (assuming title is unique)
        var document = querySnapshot.docs[0].data() as Map<String, dynamic>?;

        // Update state with details if the document is not null
        if (document != null) {
          setState(() {
            detailsTitle = document[titleField] ?? '';
            detailsDescription = document[descriptionField] ?? '';
          });
        }
      }
    } catch (e) {
      // Handle errors
      print('Error fetching details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.color.withOpacity(0.3),
              ),
              child: Center(
                child: Image.asset(
                  widget.imagePath,
                  width: 60,
                  height: 60,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Category: ${widget.category}',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Details Title: $detailsTitle',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Details Description: $detailsDescription',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
