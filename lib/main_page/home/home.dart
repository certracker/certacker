import 'package:certracker/auth/auth_service.dart';
import 'package:certracker/auth/user_data_service.dart';
import 'package:certracker/components/form/add_credential.dart';
import 'package:certracker/components/home_components/notification/notification.dart';
import 'package:certracker/components/home_components/pages/Certification.dart';
import 'package:certracker/components/home_components/pages/Education.dart';
import 'package:certracker/components/home_components/pages/License.dart';
import 'package:certracker/components/home_components/pages/Travel.dart';
import 'package:certracker/components/home_components/pages/Vaccination.dart';
import 'package:certracker/components/home_components/pages/all.dart';
import 'package:certracker/components/home_components/pages/ceu.dart';
import 'package:certracker/components/home_components/pages/others.dart';
import 'package:certracker/components/home_components/search/search_page.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  final UserDataService _userDataService = UserDataService();
  final AuthenticationService _authService = AuthenticationService();
  late String? userId;
  Map<String, dynamic>? userDetails;

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  void fetchUserDetails() async {
    userId = _authService.getCurrentUserId();
    if (userId != null) {
      userDetails = (await _userDataService.getUserDetails(userId!))
          as Map<String, dynamic>?;
      setState(() {});
    }
  }

  void _searchPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SearchPage(),
      ),
    );
  }

  void _notificationPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NotificationPage(),
      ),
    );
  }

  void selectItem(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    String profilePicture = userDetails?['profilePicture'] ?? '';
    String firstName = userDetails?['firstName'] ?? '';
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 170,
        backgroundColor: const Color(0XFF591A8F),
          automaticallyImplyLeading: false,
          elevation: 4,
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Material(
                elevation: 4,
                child: Container(
                  color: const Color(0XFF591A8F),
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: NetworkImage(profilePicture),
                      ),
                      Text(
                        "Welcome, ${firstName.length > 6 ? '${firstName.substring(0, 6)}...' : firstName}!",
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.search, color: Colors.white),
                            onPressed: _searchPage,
                          ),
                          IconButton(
                            icon: const Icon(Icons.notifications,
                                color: Colors.white),
                            onPressed: _notificationPage,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Material(
                elevation: 4,
                shadowColor: Colors.grey,
                child: Container(
                  height: 70,
                  color: Colors.white,
                  child: SingleChildScrollView(
                    scrollDirection:
                        Axis.horizontal, // Make the row scroll horizontally
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FilterItem(
                          text: 'All',
                          isSelected: selectedIndex == 0,
                          onTap: () => selectItem(0),
                        ),
                        FilterItem(
                          imagePath: "assets/images/icons/1.png",
                          isSelected: selectedIndex == 1,
                          onTap: () => selectItem(1),
                        ),
                        FilterItem(
                          imagePath: "assets/images/icons/2.png",
                          isSelected: selectedIndex == 2,
                          onTap: () => selectItem(2),
                        ),
                        FilterItem(
                          imagePath: "assets/images/icons/3.png",
                          isSelected: selectedIndex == 3,
                          onTap: () => selectItem(3),
                        ),
                        FilterItem(
                          imagePath: "assets/images/icons/4.png",
                          isSelected: selectedIndex == 4,
                          onTap: () => selectItem(4),
                        ),
                        FilterItem(
                          imagePath: "assets/images/icons/5.png",
                          isSelected: selectedIndex == 5,
                          onTap: () => selectItem(5),
                        ),
                        FilterItem(
                          imagePath: "assets/images/icons/6.png",
                          isSelected: selectedIndex == 6,
                          onTap: () => selectItem(6),
                        ),
                        FilterItem(
                          imagePath: "assets/images/icons/7.png",
                          isSelected: selectedIndex == 7,
                          onTap: () => selectItem(7),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: const [
          AllPage(),
          CertificationPage(),
          LicensesPage(),
          EducationPage(),
          VaccinationPage(),
          TravelPage(),
          CEUCMEPage(),
          OthersPage(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddCredentialPage()));
        },
        backgroundColor: const Color(0xFF591A8F),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 50),
      ),
    );
  }
}

class FilterItem extends StatelessWidget {
  final String? imagePath;
  final String? text;
  final bool isSelected;
  final VoidCallback? onTap;

  const FilterItem({
    super.key,
    this.imagePath,
    this.text,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (imagePath != null)
              Image.asset(
                imagePath!,
                width: 30,
                height: 30,
              ),
            if (text != null)
              Text(
                text!,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            if (isSelected)
              Container(
                height: 2,
                width: 30,
                color: const Color(0xFF591A8F),
                margin: const EdgeInsets.only(top: 7),
              ),
          ],
        ),
      ),
    );
  }
}
