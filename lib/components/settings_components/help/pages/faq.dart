import 'package:flutter/material.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FAQ"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildQnA(
              "What is CerTracker?",
              "CerTracker is a dedicated platform designed to assist healthcare professionals in managing and tracking their certifications, licensures, and essential documents. It ensures timely renewals and compliance with healthcare regulations.",
            ),
            _buildQnA(
              "Who can benefit from using CerTracker?",
              "CerTracker is ideal for nurses, doctors, and other healthcare workers who need to maintain various professional certifications and want a hassle-free way to manage them.",
            ),
            _buildQnA(
              "How does CerTracker remind me of my certification renewals?",
              "CerTracker uses an automated alert system that notifies you well in advance of your certification expiration dates, giving you ample time to prepare and renew.",
            ),
            _buildQnA(
              "Is my personal and professional information secure with CerTracker?",
              "Yes, CerTracker employs advanced encryption and security measures to ensure that all your data is securely stored and protected against unauthorized access.",
            ),
            _buildQnA(
              "Can I access CerTracker on multiple devices?",
              "Yes, CerTracker is designed to work across multiple devices, allowing you to manage your certifications seamlessly whether you're on a computer, tablet, or smartphone.",
            ),
            _buildQnA(
              "How does CerTracker help with the actual renewal process?",
              "While CerTracker does not renew certifications on your behalf, it provides you with timely reminders and direct links to the necessary resources to complete your renewals.",
            ),
            _buildQnA(
              "What if I have certifications from different states or countries?",
              "CerTracker is equipped to handle certifications from various jurisdictions, and you can customize the app settings to align with specific regional requirements.",
            ),
            _buildQnA(
              "How can I share my certifications with my employer or regulatory bodies?",
              "CerTracker offers a secure sharing feature that allows you to send your credentials directly from the app to any requested parties via email or other integrated platforms.",
            ),
            _buildQnA(
              "Is there a fee to use CerTracker?",
              "CerTracker offers different subscription models, including a basic free version with core functionalities, and premium plans that provide additional features for advanced users.",
            ),
            _buildQnA(
              "How do I get started with CerTracker?",
              "Simply download the app from your respective app store or go to our website, sign up for an account, and follow the intuitive setup process to begin managing your certifications.",
            ),
            _buildQnA(
              "What kind of support does CerTracker offer if I encounter issues?",
              "CerTracker provides comprehensive support through an in-app help center, email support, and an extensive online knowledge base to assist with any questions or issues.",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQnA(String question, String answer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16.0),
        Text(
          question,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Divider(),
        const SizedBox(height: 8.0),
        Text(
          answer,
          style: const TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }
}
