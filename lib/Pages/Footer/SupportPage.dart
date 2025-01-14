import 'package:flutter/material.dart';

class SupportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isSmallScreen = screenWidth < 600;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Support',
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
                  _buildSupportContent(isSmallScreen),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSupportContent(bool isSmallScreen) {
    final List<Map<String, String>> supportSections = [
      {
        'title': 'Technical Support',
        'content': """
If you face any technical issues with your purchased AC, our dedicated technical support team is here to help. From installation problems to performance issues, you can reach us 24/7 at theacsale4@gmail.com or call +91 9301778661.

Steps to resolve common technical issues:
1. Restart the AC and check power connections.
2. Ensure the remote control has functioning batteries.
3. Verify that the air filters are not clogged.

If these steps do not resolve your issue, contact us for immediate assistance. Our technicians are trained to ensure your comfort at all times.
"""
      },
      {
        'title': 'Relocation Support',
        'content': """
Planning to move to a new location? We’ve got you covered! Our relocation support ensures hassle-free transfer of your purchased AC to your new residence or office.

Process:
1. Notify us at least 48 hours before your relocation.
2. Share your new address and preferred relocation time.
3. Our team will dismantle, transport, and reinstall your AC for seamless service.

Contact our relocation support team to arrange the transfer and enjoy uninterrupted cooling wherever you go.
"""
      },
      {
        'title': 'Feedback and Complaints',
        'content': """
We value your feedback as it helps us improve our services. Whether you want to share a positive experience or highlight an issue, we are here to listen.

How to reach us:
- Email: theacsale4@gmail.com
- Phone: +91 9301778661

Complaint Resolution:
1. Submit your feedback or complaint via email or phone.
2. Our team will acknowledge your submission within 24 hours.
3. Resolution timelines depend on the complexity of the issue, but we aim to resolve all complaints within 72 hours.

Your satisfaction is our top priority, and we are committed to providing the best service possible.
"""
      },
      {
        'title': 'Billing Support',
        'content': """
Have questions about payments, invoices, or refunds? Our billing support team is here to ensure transparency and resolve any billing-related concerns.

Services we offer:
1. Clarification of purchase charges and invoices.
2. Assistance with payment methods, including online and offline options.
3. Processing of refunds as per our Refund Policy.

To get in touch with billing support:
- Email: theacsale4@gmail.com
- Phone: +91 9301778661

Ensure you have your order ID or purchase details handy for faster resolution.
"""
      },
    ];

    return Column(
      crossAxisAlignment:
          isSmallScreen ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: supportSections.map((section) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                section['title']!,
                style: TextStyle(
                  fontSize: isSmallScreen ? 18 : 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF990011),
                ),
              ),
              SizedBox(height: 12.0),
              // Content
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
