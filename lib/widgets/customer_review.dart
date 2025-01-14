import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

Widget buildCustomerReviewsSection(BoxConstraints constraints) {
  final List<Map<String, String>> reviews = [
    {
      'name': 'Anjali Sharma',
      'image': '',
      // 'image': 'https://randomuser.me/api/portraits/women/44.jpg',
      'review':
          'I got to know about The AC Sale through a friend and rented an AC. The delivery was quick and the installation seamless.',
    },
    {
      'name': 'Shreyas Rave',
      'image': '',
      // 'image': 'https://randomuser.me/api/portraits/men/32.jpg',
      'review':
          'The AC Sale was incredibly helpful when I needed an AC in my new apartment. Quick service and great customer support!',
    },
    {
      'name': 'Ritika Mehta',
      'image': '',
      // 'image': 'https://randomuser.me/api/portraits/women/55.jpg',
      'review':
          'Affordable and reliable. The AC Sale made my summer comfortable with their hassle-free services.',
    },
  ];

  final screenWidth = constraints.maxWidth;
  final isSmallScreen = screenWidth < 600;

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Section Header
        Text(
          'What Our Customers Say',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isSmallScreen ? 20 : 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF990011),
          ),
        ),
        SizedBox(height: 4),
        Container(
          height: 2,
          width: 80,
          color: Color(0xFF990011), // Underline effect
        ),
        SizedBox(height: 16),
        Text(
          "Here's what our customers have to say about their experience.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isSmallScreen ? 14 : 16,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 16),
        // Reviews Carousel
        CarouselSlider.builder(
          options: CarouselOptions(
            height: isSmallScreen ? 250 : 300,
            enlargeCenterPage: true,
            viewportFraction: isSmallScreen ? 1.0 : 0.8,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 4),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
          ),
          itemCount: reviews.length,
          itemBuilder: (context, index, realIndex) {
            final review = reviews[index];
            return Container(
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8.0,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Customer Image
                  CircleAvatar(
                    radius: isSmallScreen ? 35 : 45,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: NetworkImage(review['image']!),
                    child: Icon(
                      Icons.person,
                      size: isSmallScreen ? 35 : 45,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 16),
                  // Customer Name
                  Text(
                    review['name']!,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 16 : 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF990011),
                    ),
                  ),
                  SizedBox(height: 8),
                  // Customer Review
                  Text(
                    review['review']!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 16,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ),
  );
}
