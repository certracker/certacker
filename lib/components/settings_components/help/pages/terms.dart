import "package:flutter/material.dart";

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms and Conditions"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Terms and Conditions of Use for CerTracker",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            _buildTermsSection(
              "1. Introduction",
              "Welcome to CerTracker! These Terms and Conditions govern your use of CerTracker and the services we offer. By accessing or using our app, you agree to be bound by these terms.",
            ),
            _buildTermsSection(
              "2. Service Description",
              "CerTracker is a certification management platform for healthcare professionals, providing features to track, manage, and renew professional certifications and credentials.",
            ),
            _buildTermsSection(
              "3. User Accounts",
              "To access CerTracker, users must register and create an account. You are responsible for maintaining the confidentiality of your account information and for all activities that occur under your account.",
            ),
            _buildTermsSection(
              "4. User Obligations",
              "You agree to use CerTracker only for lawful purposes and in a way that does not infringe upon the rights of, restrict, or inhibit anyone else's use and enjoyment of the app.",
            ),
            _buildTermsSection(
              "5. Privacy Policy",
              "Your privacy is important to us. Our Privacy Policy, which is part of these Terms, describes how we collect, use, and protect your personal information.",
            ),
            _buildTermsSection(
              "6. Intellectual Property Rights",
              "All intellectual property rights in the app and its content are owned by us or our licensors. You may not use any content without our express permission, except as permitted by law.",
            ),
            _buildTermsSection(
              "7. User-Generated Content",
              "If you post content to CerTracker, you retain the rights in your content, but you grant us a license to use, store, and share it with others.",
            ),
            _buildTermsSection(
              "8. Subscription Fees",
              "CerTracker offers both free and paid subscription services. Fees for our paid services are subject to change and may be updated on our app or website.",
            ),
            _buildTermsSection(
              "9. Cancellation and Termination",
              "You may cancel your account at any time. We also reserve the right to suspend or terminate your account if you breach these Terms.",
            ),
            _buildTermsSection(
              "10. Disclaimers",
              "CerTracker is provided \"as is\" without any warranties, express or implied. We do not warrant that the app will always be available, secure, or error-free.",
            ),
            _buildTermsSection(
              "11. Limitation of Liability",
              "To the fullest extent permitted by law, we shall not be liable for any damages arising out of your use or inability to use CerTracker.",
            ),
            _buildTermsSection(
              "12. Changes to These Terms",
              "We reserve the right to modify these Terms at any time. Your continued use of CerTracker after changes have been made constitutes your acceptance of the new Terms.",
            ),
            _buildTermsSection(
              "13. Governing Law",
              "These Terms are governed by the laws of the jurisdiction where our company is registered, without regard to its conflict of law principles.",
            ),
            _buildTermsSection(
              "14. Contact Information",
              "For any questions about these Terms, please contact us at [Contact Information].",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16.0),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Divider(),
        const SizedBox(height: 8.0),
        Text(
          content,
          style: const TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }
}
