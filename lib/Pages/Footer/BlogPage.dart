import 'package:flutter/material.dart';

class BlogPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isSmallScreen = screenWidth < 600;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Blog',
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
                  _buildBlogContent(isSmallScreen),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBlogContent(bool isSmallScreen) {
    final List<Map<String, String>> blogPosts = [
      {
        "title": "5 Tips to Maintain Your AC Efficiency",
        "content":
            "Learn how to maintain your air conditioner’s efficiency with these 5 simple tips. Regular maintenance can save energy and extend the life of your AC."
      },
      {
        "title": "The Benefits of Buying an AC",
        "content":
            "Buying an AC comes with its advantages, including ownership, long-term savings, and customization options. Read more to discover why purchasing might be the right choice for you."
      },
      {
        "title": "Understanding Energy Efficiency Ratings",
        "content":
            "Learn about energy efficiency ratings and how they impact your electricity bills. Choosing the right AC can make a big difference in your energy costs."
      },
    ];

    return Column(
      crossAxisAlignment:
          isSmallScreen ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: blogPosts.map((post) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post["title"]!,
                style: TextStyle(
                  fontSize: isSmallScreen ? 16 : 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF990011),
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                post["content"]!,
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
