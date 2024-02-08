// ignore_for_file: use_build_context_synchronously

import 'dart:io';

// import 'package:certracker/auth/save_data_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:certracker/auth/auth_service.dart';
import 'package:certracker/components/home_components/category_container/category_container.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class SeleteMuiltple extends StatefulWidget {
  final String profilePicture;
  final String firstName;

  const SeleteMuiltple({
    Key? key,
    required this.profilePicture,
    required this.firstName,
  }) : super(key: key);

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
    for (var category in allCategories) {
      if (category['DocumentID'] == credentialsId) {
        print('Found $credentialsId in table ${category['tableName']}');
        return category['tableName'];
      }
    }
    print('Table name not found for $credentialsId');
    return 'UnknownTable';
  }

  String getCategoryCollectionName(String category) {
    Map<String, String> categoryCollectionMap = {
      'Certification': 'Certification',
      'License': 'License',
      'Education': 'Education',
      'Vaccination': 'Vaccination',
      'Travel': 'Travel',
      'CEU': 'CEU',
      'Others': 'Others',
    };

    return categoryCollectionMap[category] ?? '';
  }

  Future<void> fetchUserData() async {
    try {
      setState(() {
        isLoading = true;
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
    }
  }

  Future<void> deleteSelectedItems() async {
    try {
      List<Map<String, dynamic>> selectedIds = [];
      for (int i = 0; i < selectedCategories.length; i++) {
        if (selectedCategories[i]) {
          selectedIds.add(allCategories[i]);
        }
      }

      if (selectedIds.isNotEmpty) {
        // Show a confirmation dialog before deletion
        bool confirmed = await _showDeleteConfirmationDialog();

        if (confirmed) {
          // Set isLoading to true to show a loading indicator
          setState(() {
            isLoading = true;
          });

          for (Map<String, dynamic> selectedId in selectedIds) {
            String credentialsId = selectedId['credentialsId'];
            String tableName = getTableNameFromCredentialsId(credentialsId);
            print('Deleting $credentialsId from $tableName');
            await _handleDelete(credentialsId, tableName);
          }

          // Fetch user data again to update the UI
          await fetchUserData();

          // Reset the selected categories list and isLoading
          setState(() {
            selectedCategories =
                List.generate(allCategories.length, (index) => false);
            isLoading = false;
          });
        }
      } else {
        print('No selected items.');
      }
    } catch (e) {
      print('Error deleting selected items: $e');
      print('Error deleting selected items: $e, $selectedCategories');
      // Reset isLoading on error
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _handleDelete(String credentialsId, String tableName) async {
    try {
      String collectionName = getCategoryCollectionName(tableName);

      await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(credentialsId)
          .delete();

      // Show a success message or navigate back after deletion
      // For example, you can navigate back to the previous screen:
      Navigator.pop(context);
    } catch (e) {
      print('Error deleting details: $e');
      // Show an error message if deletion fails
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('An error occurred while deleting details: $e'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<bool> _showDeleteConfirmationDialog() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Confirmation'),
          content: const Text(
            'Are you sure you want to delete selected files? Once deleted, you cannot recover them.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // Close the dialog with result 'false'
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _sharePdf(BuildContext context) async {
    List<Map<String, dynamic>> selectedItems = [];
    for (int i = 0; i < selectedCategories.length; i++) {
      if (selectedCategories[i]) {
        selectedItems.add(allCategories[i]);
      }
    }

    if (selectedItems.isNotEmpty) {
      await _generatePdfFromSelectedItems(selectedItems);
    } else {
      print('No selected items.');
    }
  }

  Future<void> _generatePdfFromSelectedItems(
      List<Map<String, dynamic>> selectedItems) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) =>
            _buildPdfContentFromSelectedItems(selectedItems),
      ),
    );

    final tempPath = (await getTemporaryDirectory()).path;
    final pdfFile = File('$tempPath/selected_items.pdf');
    await pdfFile.writeAsBytes(await pdf.save());

    await Share.shareFiles([pdfFile.path], text: 'Selected Items PDF');
  }

  pw.Widget _buildPdfContentFromSelectedItems(
      List<Map<String, dynamic>> selectedItems) {
    return pw.Column(
      children: [
        for (var selectedItem in selectedItems)
          _buildPdfRow(
            ['Credential Name', selectedItem['Title']],
            [
              'Front Image',
              ['frontImageUrl']
            ],
            ['Back Imagec', selectedItem['backImageUrl']],
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
    Key? key,
    required this.selected,
    required this.onChanged,
    required this.categoryColor,
    required this.categoryImagePath,
    required this.title,
    required this.category,
  }) : super(key: key);

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
