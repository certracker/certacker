import 'package:certracker/components/form/add_credential.dart';
import 'package:certracker/components/home_components/pages/Certification.dart';
import 'package:certracker/components/home_components/pages/Education.dart';
import 'package:certracker/components/home_components/pages/License.dart';
import 'package:certracker/components/home_components/pages/Travel.dart';
import 'package:certracker/components/home_components/pages/Vaccination.dart';
import 'package:certracker/components/home_components/pages/all.dart';
import 'package:certracker/components/home_components/pages/ceu.dart';
import 'package:certracker/components/home_components/pages/others.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int selectedIndex = 0;

  void selectItem(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 4, // Adjust the elevation as needed
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            elevation: 4, // Adjust the elevation as needed
            child: Container(
              color: const Color(0XFF591A8F),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey[300],
                    child:
                        const Icon(Icons.person, size: 40, color: Colors.grey),
                  ),
                  const Text(
                    "Welcome, Devin!",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.search, color: Colors.white),
                        onPressed: () {
                          // Add notification icon onPressed action
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_vert, color: Colors.white),
                        onPressed: () {
                          // Add calendar icon onPressed action
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Material(
            elevation: 4, // Adjust the elevation as needed
            shadowColor: Colors.grey, // Optional: customize shadow color
            child: Container(
              height: 50,
              color: Colors.white,
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
          Expanded(
            child: IndexedStack(
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddCredentialPage()));
        },
        backgroundColor: const Color(0xFF591A8F),
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(50), // Adjust the circular border radius
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
    Key? key,
    this.imagePath,
    this.text,
    this.isSelected = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (imagePath != null)
              Image.asset(
                imagePath!,
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
                width: 25,
                color: const Color(0xFF591A8F),
                margin: const EdgeInsets.only(top: 7),
              ),
          ],
        ),
      ),
    );
  }
}
