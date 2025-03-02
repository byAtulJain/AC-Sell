import 'dart:async';
import 'package:ac_buy/Pages/products.dart';
import 'package:ac_buy/widgets/card_section.dart';
import 'package:ac_buy/widgets/customer_review.dart';
import 'package:ac_buy/widgets/page_route.dart';
import 'package:ac_buy/widgets/poster_slider.dart';
import 'package:ac_buy/widgets/product_heading.dart';
import 'package:ac_buy/widgets/why_choose_us.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shimmer/shimmer.dart';

import 'enquiry_page.dart';
import 'footer_widget.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String currentPage = 'Home'; // Track the current page
  List<Map<String, dynamic>> _products = [];
  bool _isLoadingProducts = true;
  bool _isLoadingSlider = true;
  List<String> _sliderImages = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _fetchSliderImages();
  }

  Future<void> _fetchProducts() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('sell products')
          .orderBy('timestamp', descending: true)
          .get();
      setState(() {
        _products = snapshot.docs
            .map((doc) => {
                  'id': doc.id,
                  'category': doc['category'],
                  'price': doc['price'],
                  'starRating': doc['starRating'],
                  'companyName': doc['companyName'],
                  'areaCovered': doc['areaCovered'],
                  'modelNo': doc['modelNo'],
                  'condition': doc['condition'],
                  'ton': doc['ton'],
                  'quantity': doc['quantity'],
                  'images': doc['images'],
                })
            .toList();
        _isLoadingProducts = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingProducts = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching products: $e')),
      );
    }
  }

  Future<void> _fetchSliderImages() async {
    // Simulate fetching local images or from Firebase
    await Future.delayed(Duration(seconds: 2)); // Simulate delay
    setState(() {
      _sliderImages = [
        'assets/images/slider1.jpg',
        'assets/images/slider2.jpg',
        'assets/images/slider3.jpg',
      ];
      _isLoadingSlider = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isSmallScreen = screenWidth < 600;
        final double baseTextScale = isSmallScreen ? 0.8 : 1.0;

        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(isSmallScreen ? 50 : 60),
            child: AppBar(
              automaticallyImplyLeading: false,
              scrolledUnderElevation: 0,
              title: Row(
                children: [
                  SizedBox(width: 10),
                  Text('The AC Sale',
                      style: TextStyle(
                        fontSize: 20 * baseTextScale,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
              actions: [
                if (!isSmallScreen) ...[
                  _buildNavButtons(baseTextScale),
                ] else
                  Builder(
                    builder: (context) => IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () => Scaffold.of(context).openEndDrawer(),
                    ),
                  ),
              ],
            ),
          ),
          endDrawer: isSmallScreen
              ? Drawer(
                  child: SafeArea(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        _buildDrawerItem(
                            Icons.home_outlined, 'Home', baseTextScale),
                        _buildDrawerItem(
                            Icons.category_outlined, 'Products', baseTextScale),
                        _buildDrawerItem(
                            Icons.contacts_outlined, 'Enquiry', baseTextScale),
                        _buildDrawerItem(
                            Icons.login_outlined, 'Login', baseTextScale),
                      ],
                    ),
                  ),
                )
              : null,
          body: _isLoadingSlider || _isLoadingProducts
              ? Center(
                  child: CircularProgressIndicator(
                  color: Color(0xFF990011),
                ))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 16),
                      buildCarouselSlider(context, baseTextScale, constraints),
                      SizedBox(height: 16),
                      buildProductsHeading(baseTextScale),
                      SizedBox(height: 8),
                      _isLoadingProducts
                          ? _buildShimmerEffect(constraints)
                          : buildCardSection(
                              context, baseTextScale, constraints,
                              products: _products, limit: 6),
                      SizedBox(height: 16),
                      buildWhyChooseUsSection(constraints),
                      SizedBox(height: 16),
                      buildCustomerReviewsSection(constraints),
                      SizedBox(height: 16),
                      AppFooter(),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _buildShimmerEffect(BoxConstraints constraints) {
    final screenWidth = constraints.maxWidth;
    final isSmallScreen = screenWidth < 1024;
    int crossAxisCount = isSmallScreen ? 2 : 3;
    double childAspectRatio = isSmallScreen ? 0.7 : 1.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: childAspectRatio,
        ),
        itemCount: 6, // Number of shimmer items to show
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              elevation: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: isSmallScreen
                        ? constraints.maxHeight * 0.15
                        : constraints.maxHeight * 0.35,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Container(
                      height: 20,
                      width: double.infinity,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      height: 20,
                      width: 100,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Container(
                      height: 20,
                      width: double.infinity,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNavButtons(double baseTextScale) {
    return Row(
      children: [
        _buildNavButton('Home', baseTextScale),
        _buildNavButton('Products', baseTextScale),
        _buildNavButton('Enquiry', baseTextScale),
        _buildNavButton('Login', baseTextScale),
      ],
    );
  }

  Widget _buildNavButton(String text, double baseTextScale) {
    bool isCurrentPage = text == currentPage;

    return TextButton(
      onPressed: () {
        setState(() {
          currentPage = text; // Update current page when clicked
        });

        // Navigate with custom animations
        if (text == 'Products') {
          Navigator.pushReplacement(
            context,
            createPageRoute(ProductsPage()),
          );
        } else if (text == 'Enquiry') {
          Navigator.pushReplacement(
            context,
            createPageRoute(EnquiryPage()),
          );
        } else if (text == 'Login') {
          Navigator.pushReplacement(
            context,
            createPageRoute(LoginPage()),
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: TextStyle(
              color: isCurrentPage ? Color(0xFF990011) : Colors.grey[700],
              fontWeight: isCurrentPage ? FontWeight.bold : FontWeight.normal,
              fontSize: 16 * baseTextScale,
            ),
          ),
          if (isCurrentPage)
            Container(
              margin: EdgeInsets.only(top: 2.0),
              height: 2.0,
              width: 30.0,
              color: Color(0xFF990011),
            ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, double baseTextScale) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF990011)),
      title: Text(title,
          style: TextStyle(
            color: Color(0xFF990011),
            fontSize: 16 * baseTextScale,
          )),
      onTap: () {
        setState(() {
          currentPage = title; // Update current page for drawer selection
        });
        Navigator.pop(context); // Close the drawer after selection

        if (title == 'Products') {
          Navigator.pushReplacement(
            context,
            createPageRoute(ProductsPage()),
          );
        } else if (title == 'Enquiry') {
          Navigator.pushReplacement(
            context,
            createPageRoute(EnquiryPage()),
          );
        } else if (title == 'Login') {
          Navigator.pushReplacement(
            context,
            createPageRoute(LoginPage()),
          );
        }
      },
    );
  }
}
