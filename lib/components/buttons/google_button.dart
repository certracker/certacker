import 'package:flutter/material.dart';

class GoogleButton extends StatelessWidget {
  final String imagepath;
  final Function()? onTap;

  const GoogleButton({super.key, required this.imagepath, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 400,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagepath,
              width: 24, // Adjust the width as needed
              height: 24, // Adjust the height as needed
            ),
            const SizedBox(width: 8), // Adjust the spacing between image and text
            const Text(
              'Sign in with Google',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
