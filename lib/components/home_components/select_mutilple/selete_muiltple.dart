import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:certracker/auth/auth_service.dart';
import 'package:certracker/auth/save_data_service.dart';
import 'package:certracker/components/home_components/category_container/category_container.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class SeleteMuiltple extends StatefulWidget {
  final String profilePicture;
  final String firstName;

  const SeleteMuiltple({
    super.key,
    required this.profilePicture,
    required this.firstName,
  });

  @override
  State<SeleteMuiltple> createState() => _SeleteMuiltpleState();
}

class _SeleteMuiltpleState extends State<SeleteMuiltple> {
  late List<Map<String, dynamic>> allCategories;
  late List<bool> selectedCategories;
  bool isLoading = true;
  String? userId;

  @override
  void initState() {
    super.initState();
    userId = AuthenticationService().getCurrentUserId();
    fetchUserData();
  }

  String getTableNameFromCredentialsId(String credentialsId) {
    // Your implementation to extract the table name from credentialsId
    // Modify this method based on your logic
    // Example implementation:
    // return credentialsId.split('_')[0];
    return 'UnknownTable';
  }

  List<String> getSelectedCategoryIds() {
    List<String> selectedIds = [];
    for (int i = 0; i < selectedCategories.length; i++) {
      if (selectedCategories[i] && allCategories[i]['DocumentID'] != null) {
        // Check for null
        selectedIds.add(allCategories[i]
            ['DocumentID']!); // Use the non-null assertion operator (!)
      }
    }
    return selectedIds;
  }

  Future<void> fetchUserData() async {
    try {
      setState(() {
        isLoading = true; // Set loading to true when starting to fetch data
      });

      userId = AuthenticationService().getCurrentUserId();

      if (userId != null) {
        List<QuerySnapshot> snapshots = await Future.wait([
          for (String collection in [
            'Certification',
            'License',
            'Education',
            'Vaccination',
            'Travel',
            'CEU',
            'Others'
          ])
            FirebaseFirestore.instance
                .collection(collection)
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

        setState(() {
          allCategories = userData;
          selectedCategories =
              List.generate(allCategories.length, (index) => false);
          isLoading =
              false; // Set loading to false after successfully fetching data
        });
      } else {
        throw Exception('User not authenticated!');
      }
    } catch (e) {
      print('Error fetching user data: $e');
      // Handle error as needed
      setState(() {
        isLoading = false; // Set loading to false in case of error
      });
    }
  }

  Future<void> deleteSelectedItems() async {
    List<String> selectedCategoryIds = getSelectedCategoryIds();

    try {
      // Move selected items to Recycle Bin
      for (String credentialsId in selectedCategoryIds) {
        await SaveDataService.moveItemToRecycleBin(
          getTableNameFromCredentialsId(credentialsId),
          userId!,
          credentialsId,
        );
      }

      // Remove selected items from the local list
      setState(() {
        allCategories.removeWhere(
            (item) => selectedCategoryIds.contains(item['DocumentID']));
        selectedCategories =
            List.generate(allCategories.length, (index) => false);
      });
    } catch (e) {
      print('Error deleting items: $e');
      // Handle error as needed
    }

    Navigator.pop(context);
  }

  Future<void> _sharePdf(BuildContext context) async {
    List<Map<String, dynamic>> selectedItems = [];
    for (int i = 0; i < selectedCategories.length; i++) {
      if (selectedCategories[i] && allCategories[i]['DocumentID'] != null) {
        selectedItems.add(allCategories[i]);
      }
    }

    if (selectedItems.isNotEmpty) {
      await _generatePdfFromSelectedItems(selectedItems);
    } else {
      // Handle case where no items are selected
      // You can show a snackbar or alert to notify the user
    }
  }

  Future<void> _generatePdfFromSelectedItems(
      List<Map<String, dynamic>> selectedItems) async {
    // Create PDF document
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) =>
            _buildPdfContentFromSelectedItems(selectedItems),
      ),
    );

    // Save PDF to a temporary file
    final tempPath = (await getTemporaryDirectory()).path;
    final pdfFile = File('$tempPath/selected_items.pdf');
    await pdfFile.writeAsBytes(await pdf.save());

    // Share the PDF file
    await Share.shareFiles([pdfFile.path], text: 'Selected Items PDF');
  }

  pw.Widget _buildPdfContentFromSelectedItems(
      List<Map<String, dynamic>> selectedItems) {
    return pw.Column(
      children: [
        for (var selectedItem in selectedItems)
          _buildPdfRow(
            ['Credential Name', selectedItem['Title']],
            ['Credential Record Number', selectedItem['otherNumber']],
            ['Issue Date', selectedItem['otherIssueDate']],
          ),
      ],
    );
  }

  pw.Widget _buildPdfRow(List<String> leftFields, List<dynamic> leftValues,
      [List<String>? rightFields, List<dynamic>? rightValues]) {
    return pw.Row(
      children: [
        pw.Expanded(child: _buildPdfFieldColumn(leftFields, leftValues)),
        if (rightFields != null && rightValues != null)
          pw.Expanded(child: _buildPdfFieldColumn(rightFields, rightValues)),
      ],
    );
  }

  pw.Widget _buildPdfFieldColumn(List<String> fields, List<dynamic> values) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: List.generate(fields.length, (index) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              fields[index], // Field name
              style: const pw.TextStyle(
                fontSize: 14.0,
              ),
            ),
            pw.SizedBox(height: 8.0),
            pw.Text(
              values[index].toString(), // Field value
              style: pw.TextStyle(
                fontSize: 16.0,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 16.0),
          ],
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 4,
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Material(
                elevation: 4,
                child: Container(
                  color: const Color(0XFF591A8F),
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: NetworkImage(widget.profilePicture),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        "Welcome, ${widget.firstName.length > 6 ? '${widget.firstName.substring(0, 6)}...' : widget.firstName}!",
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.search, color: Colors.white),
                        onPressed: () {
                          // Add notification icon onPressed action
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: allCategories.length,
              itemBuilder: (context, index) {
                final credentialsId = allCategories[index];
                String tableName = credentialsId['tableName'];
                Color categoryColor = getCategoryColor(tableName);
                String categoryImagePath = getCategoryImagePath(tableName);

                return CategoryContainerWithCheckbox(
                  selected: selectedCategories[index],
                  onChanged: (value) {
                    setState(() {
                      selectedCategories[index] = value!;
                    });
                  },
                  categoryColor: categoryColor,
                  categoryImagePath: categoryImagePath,
                  title: credentialsId['Title'],
                  category: tableName,
                );
              },
            ),
      bottomNavigationBar: BottomAppBar(
        height: 100,
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildBottomAppBarColumn(Icons.cancel, 'Cancel', () {
              Navigator.pop(context);
            }),
            _buildBottomAppBarColumn(Icons.share, 'Share', () {
              _sharePdf(
                context,
              );
            }),
            _buildBottomAppBarColumn(Icons.delete, 'Delete', () {
              deleteSelectedItems();
            }),
          ],
        ),
      ),
    );
  }

  Column _buildBottomAppBarColumn(
      IconData icon, String label, VoidCallback onTap) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon,
              color: icon == Icons.delete ? Colors.red : Colors.white),
          onPressed: onTap,
        ),
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
    );
  }

  Color getCategoryColor(String tableName) {
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
        return Colors.grey;
    }
  }

  String getCategoryImagePath(String tableName) {
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
        return "assets/images/icons/default.png";
    }
  }
}

class CategoryContainerWithCheckbox extends StatelessWidget {
  const CategoryContainerWithCheckbox({
    super.key,
    required this.selected,
    required this.onChanged,
    required this.categoryColor,
    required this.categoryImagePath,
    required this.title,
    required this.category,
  });

  final bool selected;
  final ValueChanged<bool?> onChanged;
  final Color categoryColor;
  final String categoryImagePath;
  final String title;
  final String category;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: selected ? Colors.grey[200] : null,
      leading: Checkbox(
        value: selected,
        onChanged: onChanged,
      ),
      title: CategoryContainer(
        title: title,
        category: category,
        imagePath: categoryImagePath,
        color: categoryColor,
      ),
    );
  }
}
