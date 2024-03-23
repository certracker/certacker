import 'package:certracker/registration/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:certracker/auth/auth_service.dart';
import 'function.dart'; // Import the function to delete the user account

class DeleteConfirmationPage extends StatefulWidget {
  const DeleteConfirmationPage({super.key});

  @override
  State<DeleteConfirmationPage> createState() => _DeleteConfirmationPageState();
}

class _DeleteConfirmationPageState extends State<DeleteConfirmationPage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    String? userId = AuthenticationService().getCurrentUserId();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Confirmation'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Are you sure you want to delete your account?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'This cannot be undone.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.account_circle_outlined,
                        size: 80,
                      ),
                      SizedBox(width: 20),
                      SizedBox(
                        width: 250, // Specify the desired width
                        child: Text(
                          'Your private profile will be removed permanently',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.file_copy_outlined,
                        size: 80,
                      ),
                      SizedBox(width: 20),
                      SizedBox(
                        width: 250,
                        child: Text(
                          'All your credentials will no longer be available',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 80,
                      ),
                      SizedBox(width: 20),
                      SizedBox(
                        width: 250,
                        child: Text(
                          'All notifications and reminders will automatically be cancelled',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 70),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 130,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Center(
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 130,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: GestureDetector(
                          onTap: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            await deleteUserAccount(userId!);
                            if (kDebugMode) {
                              print('User account deleted successfully $userId');
                            }
                            // Navigate to the login screen
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginPage()),
                              (route) => false,
                            );
                          },
                          child: const Center(
                            child: Text(
                              'Delete Now',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
