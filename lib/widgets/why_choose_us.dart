import 'package:flutter/material.dart';

Widget buildWhyChooseUsSection(BoxConstraints constraints) {
  final screenWidth = constraints.maxWidth;
  final isSmallScreen = screenWidth < 600;

  // List of features with online icons
  final List<Map<String, String>> features = [
    {
      'icon':
          'https://img.icons8.com/ios-filled/50/000000/air-conditioner.png', // Online icon URL
      'title': 'Finest-quality products',
      'description':
          "Quality matters to you, and us! That's why we do a strict quality-check for every product.",
    },
    {
      'icon':
          'https://img.icons8.com/ios-filled/50/000000/marker--v1.png', // Online icon URL
      'title': 'Free relocation',
      'description':
          "Changing your house or even your city? We'll relocate your rented products for free.",
    },
    {
      'icon':
          'https://img.icons8.com/ios-filled/50/000000/maintenance.png', // Online icon URL
      'title': 'Free maintenance',
      'description':
          'Keeping your rented products in a spick and span condition is on us, so you can sit back and relax.',
    },
    {
      'icon':
          'https://img.icons8.com/ios-filled/50/000000/cancel.png', // Online icon URL
      'title': 'Cancel anytime',
      'description':
          'Pay only for the time you use the product and close your subscription without any hassle.',
    },
    {
      'icon':
          'https://img.icons8.com/ios-filled/50/000000/return.png', // Online icon URL
      'title': 'Easy return on delivery',
      'description':
          "If you don't like the product on delivery, you can return it right away—no questions asked.",
    },
    {
      'icon':
          'https://img.icons8.com/ios-filled/50/000000/update-left-rotation.png', // Online icon URL
      'title': 'Keep upgrading',
      'description':
          'Bored of the same product? Upgrade to try another, newer design and enjoy the change!',
    },
  ];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Section Heading
      Text(
        'Why Choose Us?',
        style: TextStyle(
          fontSize: isSmallScreen ? 20 : 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF990011),
        ),
      ),
      SizedBox(height: 20.0),
      // Features Section
      Wrap(
        spacing: 16.0, // Horizontal spacing between items
        runSpacing: 20.0, // Vertical spacing between rows
        children: features.map((feature) {
          return Container(
            width: isSmallScreen
                ? screenWidth / 2 - 20 // 2 items per row for small screens
                : screenWidth / 3 - 20, // 3 items per row for large screens
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Feature Icon with Color Tint
                ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Color(0xFF990011), // Red tint
                    BlendMode.srcIn,
                  ),
                  child: Image.network(
                    feature['icon']!,
                    height: isSmallScreen ? 50 : 70,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 10),
                // Feature Title
                Text(
                  feature['title']!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 5),
                // Feature Description
                Text(
                  feature['description']!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 12 : 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    ],
  );
}
