import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isSmallScreen = screenWidth < 600;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Terms & Conditions',
              style: TextStyle(fontSize: 20),
            ),
            automaticallyImplyLeading: true,
            backgroundColor: Color(0xFF990011),
            foregroundColor: Color(0xFFFCF6F5),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: isSmallScreen
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.center,
                children: [
                  _buildTermsContent(isSmallScreen),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTermsContent(bool isSmallScreen) {
    final List<Map<String, String>> termsSections = [
      {
        'title': 'Introduction',
        'content':
            'Welcome to The AC Sale. These Terms & Conditions outline the rules and regulations for purchasing air conditioners through our platform. By accessing this website, we assume you accept these terms and conditions in full.'
      },
      {
        'title': 'Product Availability',
        'content':
            'We strive to ensure that our products are available as displayed. However, availability is subject to stock levels, and we reserve the right to limit quantities or discontinue products without prior notice.'
      },
      {
        'title': 'Pricing and Payments',
        'content':
            'All prices listed on our website are in accordance with market trends and may change without prior notice. Payments must be completed as per the provided payment gateway instructions to confirm your purchase.'
      },
      {
        'title': 'Warranty and Support',
        'content':
            'All ACs sold on The AC Sale are covered under their respective manufacturers’ warranties. For any issues, please refer to the warranty details provided at the time of purchase.'
      },
      {
        'title': 'Returns and Refunds',
        'content':
            'We accept returns only for defective or damaged products as per our Return Policy. Refunds will be processed within the stipulated time frame once the return is approved.'
      },
      {
        'title': 'Order Cancellation',
        'content':
            'You may cancel your order before it is dispatched. Once dispatched, cancellations will not be entertained. Refunds for canceled orders will be processed as per our Refund Policy.'
      },
      {
        'title': 'Changes to Terms',
        'content':
            'We reserve the right to update these Terms & Conditions at any time. Changes will be communicated through our website, and continued use of our services implies acceptance of the updated terms.'
      },
    ];

    return Column(
      crossAxisAlignment:
          isSmallScreen ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: termsSections.map((section) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                section['title']!,
                style: TextStyle(
                  fontSize: isSmallScreen ? 16 : 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF990011),
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                section['content']!,
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 16,
                  color: Colors.grey[800],
                  height: 1.5,
                ),
                textAlign: isSmallScreen ? TextAlign.left : TextAlign.justify,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
