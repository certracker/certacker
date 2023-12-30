import 'package:certracker/components/credentials_components/certification/certification_page.dart';
import 'package:certracker/components/credentials_components/education/education_page.dart';
import 'package:certracker/components/credentials_components/forms/cert_form.dart';
import 'package:certracker/components/credentials_components/license/license_page.dart';
import 'package:flutter/material.dart';
import 'package:floating_action_bubble_custom/floating_action_bubble_custom.dart';

class CredentialsScreen extends StatefulWidget {
  const CredentialsScreen({Key? key}) : super(key: key);

  @override
  State<CredentialsScreen> createState() => _CredentialsScreenState();
}

class _CredentialsScreenState extends State<CredentialsScreen>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;
  late IconData _currentIcon;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    final curvedAnimation = CurvedAnimation(
      curve: Curves.easeInOut,
      parent: _animationController,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    _currentIcon = Icons.add;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          bottom: const TabBar(
            tabs: [
              Tab(text: "Certification"),
              Tab(text: "Education"),
              Tab(text: "License"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            CerCertificationPage(),
            CerEducationPage(),
            CerLicensePage(),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionBubble(
          animation: _animation,
          onPressed: () {
            if (_animationController.isCompleted) {
              _animationController.reverse();
              setState(() {
                _currentIcon = Icons.add;
              });
            } else {
              _animationController.forward();
              setState(() {
                _currentIcon = Icons.close;
              });
            }
          },
          iconColor: Colors.white,
          iconData: _currentIcon,
          backgroundColor: const Color(0xFF39115B),
          shape: const CircleBorder(),
          items: <BubbleMenu>[
            BubbleMenu(
              title: "Certification",
              iconColor: Colors.black,
              bubbleColor: Colors.white,
              icon: Icons.bookmark_add,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddCertificationPage(),
                  ),
                );
              },
              style: const TextStyle(color: Colors.black),
            ),
            BubbleMenu(
              title: "Education",
              iconColor: Colors.black,
              bubbleColor: Colors.white,
              icon: Icons.book,
              onPressed: () {
                _animationController.reverse();
              },
              style: const TextStyle(color: Colors.black),
            ),
            BubbleMenu(
              title: "License",
              iconColor: Colors.black,
              bubbleColor: Colors.white,
              icon: Icons.label,
              onPressed: () {
                _animationController.reverse();
              },
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
