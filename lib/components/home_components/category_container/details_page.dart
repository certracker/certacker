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
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/widgets.dart' as pw;
// import 'pdf_utils.dart';

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

 Future<void> _handleShare(Map<String, dynamic> details) async {
  if (details['frontImageUrl'].isEmpty || details['backImageUrl'].isEmpty) {
    // Display an error dialog since there are no images
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text('No image found. Unable to share.'),
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
    return;
  }

  // Show loading indicator
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16.0),
            Text("Creating PDF and sharing..."),
          ],
        ),
      );
    },
    barrierDismissible: false, // Prevent user from dismissing the dialog
  );

  try {
    final frontImage = await networkImage(details['frontImageUrl']);
    final backImage = await networkImage(details['backImageUrl']);

    // Create PDF document
    final pdf = pw.Document();

    // Use a switch statement or a map to determine which details page to use
    pw.Widget pdfContent;
    switch (widget.category) {
      case 'Certification':
        pdfContent = CertificationDetails(details: details)
            .buildPdfContent(frontImage, backImage);
        break;
      case 'License':
        pdfContent = LicenseDetails(details: details)
            .buildPdfContent(frontImage, backImage);
        break;
      case 'Education':
        pdfContent = EducationDetails(details: details)
            .buildPdfContent(frontImage, backImage);
        break;
      case 'Vaccination':
        pdfContent = VaccinationDetails(details: details)
            .buildPdfContent(frontImage, backImage);
        break;
      case 'Travel':
        pdfContent = TravelDetails(details: details)
            .buildPdfContent(frontImage, backImage);
        break;
      case 'CEU':
        pdfContent = CEUDetails(details: details)
            .buildPdfContent(frontImage, backImage);
        break;
      case 'Others':
        pdfContent = OthersDetails(details: details)
            .buildPdfContent(frontImage, backImage);
        break;
      default:
        throw Exception('PDF content not available for this category.');
    }

    pdf.addPage(pw.Page(build: (pw.Context context) => pdfContent));

    // Save PDF to a temporary file
    final tempPath = (await getTemporaryDirectory()).path;
    final pdfFile =
        File('$tempPath/${widget.category.toLowerCase()}_details.pdf');
    await pdfFile.writeAsBytes(await pdf.save());

    // Dismiss loading indicator
    Navigator.of(context).pop();

    // Share the PDF file
    await Share.shareXFiles([XFile(pdfFile.path)],
        text: '${widget.category} Details PDF');
  } catch (e) {
    print('Error sharing details: $e');
    // Dismiss loading indicator
    Navigator.of(context).pop();

    // Display an error dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text('An error occurred while sharing details: $e'),
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
        return CertificationDetails(details: details);
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
                            onPressed: () async {
                              // Use fetchData to get the details
                              Map<String, dynamic> details = await fetchData;
                              _handleShare(details);
                            },
                            color:
                                Colors.white, // Set share icon color to white
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              // Handle delete action
                            },
                            color:
                                Colors.white, // Set delete icon color to white
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
