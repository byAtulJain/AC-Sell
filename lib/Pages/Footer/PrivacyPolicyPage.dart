import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Privacy Policy',
          style: TextStyle(fontSize: 20),
        ),
        automaticallyImplyLeading: true,
        backgroundColor: Color(0xFF990011),
        foregroundColor: Color(0xFFFCF6F5),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final isSmallScreen = screenWidth < 600;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 16.0 : 32.0,
              vertical: 24.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Information We Collect'),
                _buildSectionContent(
                  'We collect personal information such as your name, email, phone number, and shipping address when you purchase products through our website. Additionally, we may collect usage data and cookies to improve your shopping experience.',
                ),
                SizedBox(height: 16.0),
                _buildSectionTitle('How We Use Your Information'),
                _buildSectionContent(
                  'We use your personal information to process orders, provide customer support, improve our website, send you updates and promotional offers, and ensure the security of our platform.',
                ),
                SizedBox(height: 16.0),
                _buildSectionTitle('Sharing Your Information'),
                _buildSectionContent(
                  'Your personal information will never be shared, sold, or rented to third parties without your explicit consent, except as required by law or to facilitate order delivery through trusted logistics partners.',
                ),
                SizedBox(height: 16.0),
                _buildSectionTitle('Your Rights'),
                _buildSectionContent(
                  'You have the right to access, update, or delete your personal information. For any requests regarding your data, please contact us at theacsale4@gmail.com.',
                ),
                SizedBox(height: 16.0),
                _buildSectionTitle('Cookies and Tracking Technologies'),
                _buildSectionContent(
                  'We use cookies and similar tracking technologies to enhance your browsing experience, analyze website performance, and provide personalized product recommendations.',
                ),
                SizedBox(height: 16.0),
                _buildSectionTitle('Contact Us'),
                _buildSectionContent(
                  'If you have any questions or concerns regarding this Privacy Policy, feel free to contact us at theacsale4@gmail.com.',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Text(
      content,
      style: TextStyle(
        fontSize: 16,
        color: Colors.grey[700],
        height: 1.5,
      ),
    );
  }
}
