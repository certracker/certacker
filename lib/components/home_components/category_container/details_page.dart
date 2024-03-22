// ignore_for_file: use_build_context_synchronously
import 'dart:io';

import 'package:certracker/auth/auth_service.dart';
import 'package:certracker/components/home_components/category_container/details_pages/cert_details.dart';
import 'package:certracker/components/home_components/category_container/details_pages/ceu_details.dart';
import 'package:certracker/components/home_components/category_container/details_pages/edu_details.dart';
import 'package:certracker/components/home_components/category_container/details_pages/license_details.dart';
import 'package:certracker/components/home_components/category_container/details_pages/others_details.dart';
import 'package:certracker/components/home_components/category_container/details_pages/travel_details.dart';
import 'package:certracker/components/home_components/category_container/details_pages/vaccinate_details.dart';
import 'package:certracker/components/home_components/category_container/edit/certification_edit.dart';
import 'package:certracker/components/home_components/category_container/edit/ceu_edit.dart';
import 'package:certracker/components/home_components/category_container/edit/education_edit.dart';
import 'package:certracker/components/home_components/category_container/edit/license_edit.dart';
import 'package:certracker/components/home_components/category_container/edit/others_edit.dart';
import 'package:certracker/components/home_components/category_container/edit/travel_edit.dart';
import 'package:certracker/components/home_components/category_container/edit/vaccination_edit.dart';
import 'package:certracker/components/nav_bar/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class DetailsPage extends StatefulWidget {
  final String title;
  final String category;
  final String imagePath;
  final Color color;

  const DetailsPage({
    super.key,
    required this.title,
    required this.category,
    required this.imagePath,
    required this.color,
  });

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

  Future<void> _handleShare() async {
    try {
      // Fetch the details data
      Map<String, dynamic> details = await fetchData;

      // Check if the details contain the PDF path
      if (details.containsKey('pdfPath')) {
        // Get the PDF file path
        String pdfPath = details['pdfPath'];

        // Check if the PDF file exists
        if (await File(pdfPath).exists()) {
          // Share the PDF file using share_plus package
          await Share.shareFiles([pdfPath], text: 'Sharing PDF file');
        } else {
          // Show a dialog if the PDF file doesn't exist
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Error'),
                content: const Text('PDF file not found'),
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
      } else {
        // Show a dialog if the PDF path is not available
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('PDF file not available'),
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
    } catch (e) {
      print('Error sharing document: $e');
      // Show an error dialog if sharing fails
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('An error occurred while sharing document: $e'),
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

  void _showDeleteConfirmationDialog() {
    bool isDeleting = false; // Track if deletion is in progress

    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent closing the dialog by tapping outside
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => !isDeleting,
          child: AlertDialog(
            title: const Text('Delete Confirmation'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Are you sure you want to delete this file? Once deleted, you cannot recover it.',
                ),
                if (isDeleting)
                  const SizedBox(
                      height: 16.0), // Add some space for the loading indicator
                if (isDeleting)
                  const CircularProgressIndicator(), // Loading indicator
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: isDeleting
                    ? null
                    : () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: isDeleting
                    ? null
                    : () async {
                        // Set the isDeleting flag to true to show the loading indicator
                        setState(() {
                          isDeleting = true;
                        });

                        // Call the method to delete the data from Firebase
                        await _handleDelete();

                        // Navigate to the replacement page after deletion
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BottomNavBar()),
                        );
                      },
                child: const Text('Delete'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleDelete() async {
    try {
      String collectionName = getCategoryCollectionName(widget.category);
      String credentialsId = (await fetchData)['credentialsId'];

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

  void _handleEdit() async {
    Map<String, dynamic> details = await fetchData;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          switch (widget.category) {
            case 'Certification':
              return EditCertificationPage(
                initialDetails: details,
                credentialsId: details['credentialsId'],
              );
            case 'License':
              return EditLicensePage(
                initialDetails: details,
                credentialsId: details['credentialsId'],
              );
            case 'Education':
              return EditEducationPage(
                initialDetails: details,
                credentialsId: details['credentialsId'],
              );
            case 'Vaccination':
              return EditVaccinationPage(
                initialDetails: details,
                credentialsId: details['credentialsId'],
              );
            case 'Travel':
              return EditTravelPage(
                initialDetails: details,
                credentialsId: details['credentialsId'],
              );
            case 'CEU':
              return EditCEUPage(
                initialDetails: details,
                credentialsId: details['credentialsId'],
              );
            case 'Others':
              return EditOthersPage(
                initialDetails: details,
                credentialsId: details['credentialsId'],
              );
            default:
              return const Text('Edit form not available for this category.');
          }
        },
      ),
    );
  }

  Future<Map<String, dynamic>> fetchDetails() async {
    try {
      String collectionName = getCategoryCollectionName(widget.category);
      String userId = AuthenticationService().getCurrentUserId() ?? '';

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(collectionName)
          .where('userId', isEqualTo: userId)
          .where('Title', isEqualTo: widget.title)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic> details =
            querySnapshot.docs.first.data() as Map<String, dynamic>;

        // Include 'credentialsId' in the details
        details['credentialsId'] = querySnapshot.docs.first.id;

        // Exclude 'timestamp' field
        // details.remove('timestamp');

        // Download PDF and add its path to details
        String pdfUrl = details['FileDownloadUrl'];
        final response = await http.get(Uri.parse(pdfUrl));
        final bytes = response.bodyBytes;
        final appDir = await getApplicationDocumentsDirectory();
        final pdfPath = '${appDir.path}/certification.pdf';
        final pdfFile = File(pdfPath);
        await pdfFile.writeAsBytes(bytes);
        details['pdfPath'] = pdfPath;

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
      'CEU': 'CEU',
      'Others': 'Others',
    };

    return categoryCollectionMap[category] ?? '';
  }

  Widget buildDetailsUI(Map<String, dynamic> details) {
    switch (widget.category) {
      case 'Certification':
        return CertificationDetails(
          details: details,
        );
      case 'License':
        return LicenseDetails(details: details);
      case 'Education':
        return EducationDetails(details: details);
      case 'Vaccination':
        return VaccinationDetails(details: details);
      case 'Travel':
        return TravelDetails(details: details);
      case 'CEU':
        return CEUDetails(details: details);
      case 'Others':
        return OthersDetails(details: details);
      default:
        return const Text('No details available for this category.');
    }
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
                      fit: BoxFit.fitHeight,
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
                        color: Colors.white,
                      ),
                    ),
                    Positioned(
                      top: 16.0,
                      right: 16.0,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: _handleEdit,
                            color: Colors.white, // Set edit icon color to white
                          ),
                          IconButton(
                            icon: const Icon(Icons.share),
                            onPressed: _handleShare,
                            color:
                                Colors.white, // Set share icon color to white
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: _showDeleteConfirmationDialog,
                            color: Colors.white,
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

                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: buildDetailsUI(details),
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
