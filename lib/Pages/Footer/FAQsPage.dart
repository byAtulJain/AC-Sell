import 'package:flutter/material.dart';

class FAQsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isSmallScreen = screenWidth < 600;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              "FAQs",
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
                  _buildFAQsContent(isSmallScreen),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFAQsContent(bool isSmallScreen) {
    final List<Map<String, String>> faqSections = [
      {
        "question": "What products does The AC Sale offer?",
        "answer":
            "The AC Sale specializes in providing high-quality air conditioners for residential and commercial use. We offer a variety of models, including split, window, and portable ACs, catering to different cooling needs."
      },
      {
        "question": "How can I place an order?",
        "answer":
            "To place an order, simply browse our website, select the AC model that suits your needs, add it to the cart, and proceed to checkout. Provide your delivery details, make the payment, and confirm your purchase. Our team will handle the rest."
      },
      {
        "question": "Do you provide installation services?",
        "answer":
            "Yes, we provide professional installation services for all AC purchases. Our technicians will ensure that your AC is installed correctly and functions optimally."
      },
      {
        "question": "What is your warranty policy?",
        "answer":
            "All ACs sold on The AC Sale come with a manufacturer's warranty. The warranty terms vary by model and manufacturer. Please check the specific warranty details provided with your product."
      },
      {
        "question": "Can I return or exchange a product?",
        "answer":
            "We accept returns or exchanges only for defective or damaged products. Please report any issues within 7 days of delivery to initiate a return or exchange."
      },
      {
        "question": "What payment methods do you accept?",
        "answer":
            "We accept multiple payment methods, including credit/debit cards, net banking, UPI, and wallet payments. All transactions are secure and encrypted."
      },
      {
        "question": "How long does delivery take?",
        "answer":
            "Delivery times vary based on your location. Typically, orders are delivered within 3-7 business days. You will receive a tracking link once your order is shipped."
      },
      {
        "question": "Do you offer maintenance services?",
        "answer":
            "While we do not provide ongoing maintenance services, we recommend regular servicing to ensure optimal performance of your AC. Refer to the product manual for maintenance guidelines.",
      },
      {
        "question": "How can I contact customer support?",
        "answer":
            "You can reach our customer support team by emailing us at theacsale4@gmail.com. We are happy to assist you with any queries or concerns."
      },
    ];

    return Column(
      crossAxisAlignment:
          isSmallScreen ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: faqSections.map((faq) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Question
              Text(
                faq["question"]!,
                style: TextStyle(
                  fontSize: isSmallScreen ? 16 : 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF990011),
                ),
              ),
              SizedBox(height: 8.0),
              // Answer
              Text(
                faq["answer"]!,
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 16,
                  color: Colors.grey[800],
                  height: 1.6,
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
