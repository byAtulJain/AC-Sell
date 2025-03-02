import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../widgets/page_route.dart';
import 'enquiry_page.dart';

class DetailPage extends StatelessWidget {
  final List<String> images; // Accept multiple images
  final String category;
  final String starRating;
  final String companyName;
  final String modelNo; // Add modelNo field
  final String condition; // Add condition field
  final String areaCovered;
  final String ton;
  final String price;
  final String quantity;

  DetailPage({
    required this.images,
    required this.category,
    required this.starRating,
    required this.companyName,
    required this.modelNo, // Add modelNo field
    required this.condition, // Add condition field
    required this.areaCovered,
    required this.ton,
    required this.price,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isSmallScreen = screenWidth < 600;
        return Scaffold(
          appBar: AppBar(
            scrolledUnderElevation: 0,
            title: Text('$companyName AC $ton Ton'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: isSmallScreen
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildImageSection(),
                        SizedBox(height: 16),
                        _buildDetailsSection(),
                        SizedBox(height: 16),
                        _buildEnquiryButton(context),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image Section on the left
                        Expanded(
                          flex: 1,
                          child: _buildImageSection(),
                        ),
                        SizedBox(width: 16),
                        // Details Section and Button on the right
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDetailsSection(),
                              SizedBox(height: 16),
                              _buildEnquiryButton(context),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageSection() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 350, // Set desired height
        viewportFraction: 1.0,
        enableInfiniteScroll: true,
        autoPlay: true,
      ),
      items: images.map((imageUrl) {
        return Builder(
          builder: (BuildContext context) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.fitWidth,
                width: double.infinity,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 350,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                ),
                errorWidget: (context, url, error) =>
                    Icon(Icons.broken_image, size: 200), // Placeholder
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          '$companyName AC $ton Ton',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        // Category Tag
        Container(
          padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          decoration: BoxDecoration(
            color: Color(0xFF990011), // Background color for tag
            borderRadius: BorderRadius.circular(8.0), // Rounded corners
          ),
          child: Text(
            category, // Display the category text
            style: TextStyle(
              fontSize: 14,
              color: Colors.white, // Text color
            ),
          ),
        ),
        SizedBox(height: 8),
        // Star Rating
        Row(
          children: List.generate(
            int.parse(starRating.split('.')[0]),
            (index) => Icon(
              Icons.star,
              color: Color(0xFF990011),
              size: 20,
            ),
          ),
        ),
        SizedBox(height: 8),
        // Company Name
        Text(
          'Company: $companyName',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        // Model No.
        Text(
          'Model No: $modelNo',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        // Condition
        Text(
          'Condition: $condition',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        // Area Covered
        Text(
          'Area Covered: $areaCovered sq. ft.',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        // Ton
        Text(
          'Ton: $ton Ton',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        // Ton
        Text(
          'Quantity: $quantity Pieces',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        // Price
        Text(
          'Price: Rs. $price',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.green,
          ),
        ),
        SizedBox(height: 16),
        // Description
        // Text(
        //   description,
        //   style: TextStyle(
        //     fontSize: 16,
        //     color: Colors.grey[700],
        //   ),
        //   textAlign: TextAlign.justify,
        // ),
      ],
    );
  }

  Widget _buildEnquiryButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            createPageRoute(EnquiryPage()),
          );
        },
        style: ElevatedButton.styleFrom(
          primary: Color(0xFF990011), // Button background color
          padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(
          'Enquiry Now',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
