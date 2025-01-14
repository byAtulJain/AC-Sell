import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shimmer/shimmer.dart';

import '../main.dart';
import '../widgets/page_route.dart';
import '../widgets/card_section.dart'; // Import the card_section.dart
import 'enquiry_page.dart';
import 'footer_widget.dart';
import 'login_page.dart';

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  String currentPage = 'Products';
  String selectedCategory = 'All'; // Default selected category
  List<Map<String, dynamic>> _categories = [];
  bool _isLoadingCategories = true;
  List<Map<String, dynamic>> _products = [];
  bool _isLoadingProducts = true;
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'Recently Added';

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _fetchProducts();
  }

  Future<void> _fetchCategories() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('sell categories').get();
      setState(() {
        _categories = [
          {'id': 'all', 'name': 'All'}
        ];
        _categories.addAll(snapshot.docs
            .map((doc) => {'id': doc.id, 'name': doc['name']})
            .toList());
        _isLoadingCategories = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingCategories = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching categories: $e')),
      );
    }
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
                  'ton': doc['ton'],
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

  List<Map<String, dynamic>> _getFilteredProducts() {
    // Always start with the full product list to avoid retaining previous filters
    List<Map<String, dynamic>> filteredProducts = List.from(_products);

    // Apply category filter
    if (selectedCategory != 'All') {
      filteredProducts = filteredProducts
          .where((product) => product['category'] == selectedCategory)
          .toList();
    }

    // Apply search query filter
    if (_searchQuery.isNotEmpty) {
      filteredProducts = filteredProducts.where((product) {
        return product['companyName']
                .toString()
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            product['category']
                .toString()
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            product['price']
                .toString()
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            product['starRating']
                .toString()
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            product['areaCovered']
                .toString()
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            product['ton']
                .toString()
                .toLowerCase()
                .contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Apply sorting filter
    if (_selectedFilter == 'Low to High') {
      filteredProducts.sort(
          (a, b) => int.parse(a['price']).compareTo(int.parse(b['price'])));
    } else if (_selectedFilter == 'High to Low') {
      filteredProducts.sort(
          (a, b) => int.parse(b['price']).compareTo(int.parse(a['price'])));
    } else if (_selectedFilter == 'Recently Added') {
      filteredProducts.sort((a, b) {
        final timestampA =
            a['timestamp'] ?? DateTime.fromMillisecondsSinceEpoch(0);
        final timestampB =
            b['timestamp'] ?? DateTime.fromMillisecondsSinceEpoch(0);
        return timestampB.compareTo(timestampA);
      });
    }

    return filteredProducts;
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filter by Price'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Recently Added'),
                leading: Radio<String>(
                  value: 'Recently Added',
                  groupValue: _selectedFilter,
                  onChanged: (value) {
                    setState(() {
                      _selectedFilter = value!;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ),
              ListTile(
                title: Text('Low to High'),
                leading: Radio<String>(
                  value: 'Low to High',
                  groupValue: _selectedFilter,
                  onChanged: (value) {
                    setState(() {
                      _selectedFilter = value!;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ),
              ListTile(
                title: Text('High to Low'),
                leading: Radio<String>(
                  value: 'High to Low',
                  groupValue: _selectedFilter,
                  onChanged: (value) {
                    setState(() {
                      _selectedFilter = value!;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
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
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 16),
                _buildSearchBar(baseTextScale),
                SizedBox(height: 16),
                _isLoadingCategories
                    ? _buildShimmerCategories(baseTextScale)
                    : _buildCategoriesSection(
                        baseTextScale), // Category section
                SizedBox(height: 16),
                _isLoadingProducts
                    ? _buildShimmerProducts(constraints)
                    : _buildProductsSection(baseTextScale, constraints),
                SizedBox(height: 16),
                AppFooter(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchBar(double baseTextScale) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Color(0xFF990011)),
                hintText: "Search Products",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Color(0xFF990011)),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          SizedBox(width: 10),
          IconButton(
            icon: Icon(Icons.filter_alt, color: Color(0xFF990011)),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection(double baseTextScale) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _categories.map((category) {
            bool isSelected = selectedCategory == category['name'];
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedCategory =
                      category['name']; // Update the selected category
                  print('Selected category: ${category['name']}');
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Color(0xFF990011)
                        : Colors.transparent, // Fill for selected
                    border: Border.all(
                      color: Color(0xFF990011), // Border for both states
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Text(
                    category['name'],
                    style: TextStyle(
                      fontSize: 14 * baseTextScale,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? Colors.white
                          : Color(
                              0xFF990011), // White for selected, red for unselected
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildProductsSection(
      double baseTextScale, BoxConstraints constraints) {
    final filteredProducts = _getFilteredProducts();

    return buildCardSection(context, baseTextScale, constraints,
        limit: null, products: filteredProducts);
  }

  Widget _buildShimmerCategories(double baseTextScale) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(5, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Text(
                    'Loading',
                    style: TextStyle(
                      fontSize: 14 * baseTextScale,
                      fontWeight: FontWeight.bold,
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildShimmerProducts(BoxConstraints constraints) {
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
    bool isCurrentPage =
        text == currentPage; // Check if this is the current page
    return TextButton(
      onPressed: () {
        if (text == 'Home') {
          Navigator.pushReplacement(
            context,
            createPageRoute(HomePage()),
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
        Navigator.pop(context);
        if (title == 'Home') {
          Navigator.pushReplacement(
            context,
            createPageRoute(HomePage()),
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
