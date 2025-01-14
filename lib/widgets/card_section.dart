import 'package:ac_buy/widgets/page_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shimmer/shimmer.dart';

import '../Pages/enquiry_page.dart';
import '../Pages/product_detail_page.dart';
import '../Pages/products.dart';

Widget buildCardSection(
    BuildContext context, double baseTextScale, BoxConstraints constraints,
    {required List<Map<String, dynamic>> products, int? limit}) {
  final screenWidth = constraints.maxWidth;
  final isSmallScreen = screenWidth < 1024;

  // Determine grid parameters
  int crossAxisCount = isSmallScreen ? 2 : 3;
  double childAspectRatio = isSmallScreen ? 0.7 : 1.0;

  // Limit the number of items if limit is provided
  final displayedProducts =
      limit != null ? products.take(limit).toList() : products;

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: displayedProducts.length,
          itemBuilder: (context, index) {
            return _buildProductCard(
                context, displayedProducts[index], baseTextScale, constraints);
          },
        ),
        if (limit != null) ...[
          SizedBox(height: 16.0),
          // Explore More Text
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                // Navigate to the ProductsPage
                Navigator.push(
                  context,
                  createPageRoute(ProductsPage()),
                );
              },
              child: Text(
                'See More >>',
                style: TextStyle(
                  fontSize:
                      isSmallScreen ? 12 : 14, // Adjust font size for screens
                  color: Color(0xFF990011),
                ),
              ),
            ),
          ),
        ],
      ],
    ),
  );
}

Widget _buildProductCard(BuildContext context, Map<String, dynamic> product,
    double baseTextScale, BoxConstraints constraints) {
  final screenWidth = constraints.maxWidth;
  final isSmallScreen = screenWidth < 1024;
  final isLargeScreen = screenWidth >= 1024;
  // Dynamic image height
  double imageHeight = isSmallScreen
      ? constraints.maxHeight * 0.15
      : constraints.maxHeight * 0.35;

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        createPageRoute(
          DetailPage(
            images: List<String>.from(product['images']),
            category: product['category'],
            starRating: product['starRating'],
            companyName: product['companyName'],
            areaCovered: product['areaCovered'],
            ton: product['ton'],
            price: product['price'],
          ),
        ),
      );
    },
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16.0),
            ),
            child: CachedNetworkImage(
              imageUrl: product['images'][0],
              fit: BoxFit.cover,
              height: imageHeight,
              width: double.infinity,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  height: imageHeight,
                  width: double.infinity,
                  color: Colors.white,
                ),
              ),
              errorWidget: (context, url, error) =>
                  Icon(Icons.broken_image, size: imageHeight),
            ),
          ),
          // Heading Section
          Padding(
            padding: EdgeInsets.all(8.0 * baseTextScale),
            child: Text(
              '${product['companyName']} AC ${product['ton']} Ton',
              style: TextStyle(
                fontSize: 16 * baseTextScale,
                fontWeight: FontWeight.bold,
                color: Color(0xFF990011),
              ),
            ),
          ),
          // Star Rating Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0 * baseTextScale),
            child: Row(
              children: List.generate(
                int.parse(product['starRating'].split('.')[0]),
                (index) => Icon(
                  Icons.star,
                  color: Color(0xFF990011),
                  size: 20 * baseTextScale,
                ),
              ),
            ),
          ),
          // Company Name Section
          if (!isLargeScreen)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0 * baseTextScale),
              child: Text(
                'Rs.${product['price']}',
                style: TextStyle(
                  fontSize: 14 * baseTextScale,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
          // Area Covered Section (only for large screens)
          if (isLargeScreen)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0 * baseTextScale),
              child: Text(
                'Area Covered: ${product['areaCovered']} sq. ft.',
                style: TextStyle(
                  fontSize: 14 * baseTextScale,
                  color: Colors.black,
                ),
              ),
            ),
          // Enquiry Button Section
          Padding(
            padding: EdgeInsets.all(8.0 * baseTextScale),
            child: isLargeScreen
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Display Price for all screens
                      Text(
                        'Rs.${product['price']}',
                        style: TextStyle(
                          fontSize: 14 * baseTextScale,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFF990011),
                          padding: EdgeInsets.symmetric(
                            vertical: 16.0 * baseTextScale,
                            horizontal: 16.0 * baseTextScale,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            createPageRoute(EnquiryPage()),
                          );
                        },
                        child: Text(
                          'Enquiry Now',
                          style: TextStyle(
                            fontSize: 14 * baseTextScale,
                            color: Color(0xFFFCF6F5),
                          ),
                        ),
                      ),
                    ],
                  )
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF990011),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          createPageRoute(EnquiryPage()),
                        );
                      },
                      child: Text(
                        'Enquiry Now',
                        style: TextStyle(
                          fontSize: 14 * baseTextScale,
                          color: Color(0xFFFCF6F5),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    ),
  );
}
