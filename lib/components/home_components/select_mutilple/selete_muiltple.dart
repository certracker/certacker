import 'package:certracker/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:certracker/components/home_components/category_container/category_container.dart';

class SeleteMuiltple extends StatefulWidget {
  const SeleteMuiltple({super.key});

  @override
  State<SeleteMuiltple> createState() => _SeleteMuiltpleState();
}

class _SeleteMuiltpleState extends State<SeleteMuiltple> {
  late List<Map<String, dynamic>> allCategories;
  late List<bool> selectedCategories;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  String getTableNameFromCredentialsId(String credentialsId) {
    // Split the credentials ID by underscore
    List<String> parts = credentialsId.split('_');

    // Check if there are parts after splitting
    if (parts.isNotEmpty) {
      // The first part is the table name
      return parts[0];
    } else {
      // Return a default table name or handle the case as needed
      return 'UnknownTable';
    }
  }

  List<String> getSelectedCategoryIds() {
  List<String> selectedIds = [];
  for (int i = 0; i < selectedCategories.length; i++) {
    if (selectedCategories[i] && allCategories[i]['DocumentID'] != null) {
      selectedIds.add(allCategories[i]['DocumentID']);
    }
  }
  return selectedIds;
}


  Future<void> moveToRecycleBin(List<String> selectedCategoryIds) async {
    try {
      String? userId = AuthenticationService().getCurrentUserId();

      if (userId != null) {
        for (String credentialsId in selectedCategoryIds) {
          // Iterate through each selected item and move it to the "Recycle Bin"
          String tableName = getTableNameFromCredentialsId(credentialsId);
          Map<String, dynamic> selectedItem = allCategories
              .firstWhere((item) => item['DocumentID'] == credentialsId);

          await FirebaseFirestore.instance
              .collection('RecycleBin')
              .doc(tableName)
              .collection(tableName)
              .doc(credentialsId)
              .set(selectedItem);

          // Delete the item from the current collection
          await FirebaseFirestore.instance
              .collection(tableName)
              .doc(credentialsId)
              .delete();
        }

        // Reload user data after moving items to the "Recycle Bin"
        await fetchUserData();
      } else {
        throw Exception('User not authenticated!');
      }
    } catch (e) {
      print('Error moving items to Recycle Bin: $e');
      // Handle error as needed
    }
  }

  Future<void> fetchUserData() async {
    try {
      setState(() {
        isLoading = true; // Set loading to true when starting to fetch data
      });

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

        setState(() {
          allCategories = userData;
          selectedCategories =
              List.generate(allCategories.length, (index) => false);
          isLoading = false; // Set loading to false after successfully fetching data
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Multiple'),
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

                return ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Checkbox(
                    value: selectedCategories[index],
                    onChanged: (value) {
                      setState(() {
                        selectedCategories[index] = value!;
                      });
                    },
                  ),
                  title: CategoryContainer(
                    title: credentialsId['Title'],
                    category: tableName,
                    imagePath: categoryImagePath,
                    color: categoryColor,
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomAppBar(
        height: 100,
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.cancel, color: Colors.white),
                  onPressed: () {
                    // Handle cancel action
                    Navigator.pop(context);
                  },
                ),
                const Text('Cancel', style: TextStyle(color: Colors.white)),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.share, color: Colors.green),
                  onPressed: () {
                    // Handle share action
                  },
                ),
                const Text('Share', style: TextStyle(color: Colors.white)),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    // Handle delete action
                    deleteSelectedItems();
                  },
                ),
                const Text('Delete', style: TextStyle(color: Colors.white)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void deleteSelectedItems() async {
    List<String> selectedCategoryIds = getSelectedCategoryIds();

    try {
      // Move selected items to Recycle Bin
      await moveToRecycleBin(selectedCategoryIds);

      // Remove selected items from the local list
      setState(() {
        allCategories.removeWhere((item) =>
            selectedCategoryIds.contains(item['DocumentID']));
        selectedCategories =
            List.generate(allCategories.length, (index) => false);
      });
    } catch (e) {
      print('Error deleting items: $e');
      // Handle error as needed
    }

    Navigator.pop(context);
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
