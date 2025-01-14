import 'package:flutter/material.dart';

class RefundPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Refund Policy',
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
                _buildSectionTitle('Cancellation Policy'),
                _buildSectionContent(
                  'You can cancel your order anytime before it is dispatched. Once the order is dispatched, cancellations will not be entertained.',
                ),
                SizedBox(height: 16.0),
                _buildSectionTitle('Refund Eligibility'),
                _buildSectionContent(
                  'Refunds are only provided for defective products or products damaged during transit. Please report such issues within 7 days of receiving the product.',
                ),
                SizedBox(height: 16.0),
                _buildSectionTitle('Refund Process'),
                _buildSectionContent(
                  'To request a refund, contact us at theacsale4@gmail.com with your order details and proof of the issue. Once approved, the refund will be processed within 5-7 business days.',
                ),
                SizedBox(height: 16.0),
                _buildSectionTitle('Non-Refundable Items'),
                _buildSectionContent(
                  'Delivery charges, installation fees, and any damages caused by improper handling or usage are non-refundable.',
                ),
                SizedBox(height: 16.0),
                _buildSectionTitle('Contact Us'),
                _buildSectionContent(
                  'If you have any questions about this Refund Policy, please contact us at theacsale4@gmail.com.',
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
