import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "About CerTracker",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("About CerTracker"),
            _buildParagraph(
              "Our Mission",
              "At CerTracker, our mission is to empower healthcare professionals by providing a seamless and intuitive solution for managing their certifications and credentials. We understand the importance of staying compliant with industry standards and regulations, and we’re here to make that process as straightforward and stress-free as possible.",
            ),
            _buildParagraph(
              "Our Vision",
              "We envision a world where healthcare professionals can dedicate their time and expertise to what truly matters - patient care. CerTracker aims to eliminate the administrative overhead of certification management, enabling professionals to focus on their personal and professional growth without the looming worry of paperwork and deadlines.",
            ),
            _buildParagraph(
              "What We Do",
              "CerTracker is a comprehensive certification management system designed specifically for the healthcare sector. We provide an array of features tailored to the unique needs of healthcare practitioners, including:",
              bullets: [
                "Automated alerts for certification renewals",
                "Digital storage and easy access to credential documents",
                "A user-friendly interface for tracking continuing education units (CEUs)",
                "Secure and confidential data handling",
              ],
            ),
            _buildParagraph(
              "Our Commitment",
              "We are committed to continuous improvement and innovation, ensuring that our platform not only meets but exceeds the expectations of our users. CerTracker is more than just an app; it's a trusted partner in your professional journey.",
            ),
            _buildParagraph(
              "Why CerTracker?",
              "In the fast-paced world of healthcare, staying ahead of certification renewals and maintaining proper documentation can be challenging. CerTracker was developed to alleviate that burden. With CerTracker, you have a dedicated ally in your corner, one that understands the complexities of your profession and provides a solution that is as dynamic as it is reliable.",
            ),
            _buildSectionTitle("Our Values"),
            _buildParagraph(
              "Diversity",
              "We celebrate the varied backgrounds of our users and strive to create an inclusive platform for all.",
            ),
            _buildParagraph(
              "Innovation",
              "Our drive for innovation keeps us at the forefront of certification management technology.",
            ),
            _buildParagraph(
              "Integrity",
              "We pledge to uphold the highest standards of integrity in every aspect of our service.",
            ),
            _buildParagraph(
              "Excellence",
              "We are relentless in our pursuit of excellence, ensuring our users receive nothing but the best.",
            ),
            _buildParagraph(
              "Family",
              "We recognize the importance of family and aim to provide a service that helps our users balance their professional and personal lives.",
            ),
            _buildParagraph(
              "Support",
              "Our dedication to support means we're always here to help our users succeed and thrive.",
            ),
            _buildSectionTitle("Join the CerTracker Community"),
            _buildParagraph(
              "Joining CerTracker",
              "By joining CerTracker, you’re not just adopting a new platform; you're joining a community of like-minded professionals who value efficiency, accuracy, and reliability. Embrace the future of certification management today with CerTracker.",
            ),
            _buildParagraph(
              "Get In Touch",
              "For more information or to get in touch with the CerTracker team, please email [support@certracker.com].",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParagraph(String title, String content, {List<String>? bullets}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          content,
          style: const TextStyle(fontSize: 16.0),
        ),
        if (bullets != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: bullets
                .map((bullet) => Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Row(
                        children: [
                          const Text("• "),
                          Expanded(child: Text(bullet)),
                        ],
                      ),
                    ))
                .toList(),
          ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16.0),
        Text(
          title,
          style: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Divider(),
      ],
    );
  }
}
