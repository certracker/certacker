import 'package:certracker/components/colors/app_colors.dart';
import 'package:certracker/registration/signup/signup.dart';
import 'package:flutter/material.dart';

class OnBoard extends StatefulWidget {
  const OnBoard({super.key});

  @override
  State<OnBoard> createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "assets/images/onboarding/bg.png",
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: [
              buildOnboardingScreen(
                "Manage Certifications and Credentials Efficiently",
                "Effortlessly manage and store your certifications, credentials, and important documents.",
                "assets/images/onboarding/1.jpg",
                0,
              ),
              buildOnboardingScreen(
                "Synchronized Expiration and Renewal Date Management",
                "Take control of your renewal and expiration timelines with our comprehensive management system. Get advanced alerts for upcoming dates, ensuring no deadline is missed.",
                "assets/images/onboarding/2.jpg",
                1,
              ),
              buildOnboardingScreen(
                "Seamlessly Share Licenses, Certifications, and Important Documents",
                "Our platform enables quick, secure sharing, simplifying your professional documentation management.",
                "assets/images/onboarding/3.jpg",
                2,
                isLastPage: true,
              ),
            ],
          ),
          Positioned(
            top: 50,
            right: 20, // Changed from left: 20 to right: 20
            child: Image.asset(
              "assets/images/onboarding/onlogo.png",
              height: 120,
              width: 120,
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: _currentPage != 2
                ? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          3,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            width: _currentPage == index
                                ? 30
                                : 10, // Change the width of the active dot
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape
                                  .rectangle, // Change shape to rectangle for active dot
                              borderRadius: BorderRadius.circular(
                                  5), // Optional: round corners for rectangle
                              color: _currentPage == index
                                  ? const Color(0xFF7E25CA)
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease,
                          );
                        },
                        child: const Text(
                          'Next',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignUpPage()),
                        );
                      },
                      child: SizedBox(
                        width: 170, // Set the desired width here
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                CustomColors.gradientStart,
                                CustomColors.gradientEnd,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(18),
                          child: const Text(
                            "Finish",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget buildOnboardingScreen(
    String header,
    String description,
    String imagePath,
    int pageIndex, {
    bool isLastPage = false,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            height: 200,
            width: 200,
          ),
          Text(
            header,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF7E25CA),
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
