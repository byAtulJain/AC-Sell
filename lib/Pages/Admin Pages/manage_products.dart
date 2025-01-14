import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shimmer/shimmer.dart';
import '../../widgets/page_route.dart';
import 'edit_product.dart'; // Import the EditProductPage

class ManageProductsPage extends StatefulWidget {
  @override
  _ManageProductsPageState createState() => _ManageProductsPageState();
}

class _ManageProductsPageState extends State<ManageProductsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final snapshot = await _firestore.collection('sell products').get();
      setState(() {
        _products = snapshot.docs.map((doc) {
          final data = doc.data();
          return {
            'id': doc.id,
            ...data,
          };
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching products: $e')),
      );
    }
  }

  Future<void> _deleteProduct(String productId, List<String> imageUrls) async {
    try {
      // Delete images from Firebase Storage
      for (String url in imageUrls) {
        final ref = FirebaseStorage.instance.refFromURL(url);
        await ref.delete();
      }

      // Delete the product document from Firestore
      await _firestore.collection('sell products').doc(productId).delete();

      // Delete related enquiries
      final enquirySnapshot = await _firestore
          .collection('Sell Enquiry')
          .where('selectedProduct',
              isEqualTo: _firestore.collection('sell products').doc(productId))
          .get();

      for (var doc in enquirySnapshot.docs) {
        await doc.reference.delete();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Product and related enquiries deleted successfully!')),
      );
      _fetchProducts();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting product: $e')),
      );
    }
  }

  Widget _buildProductCard(BuildContext context, Map<String, dynamic> product,
      double baseTextScale, BoxConstraints constraints) {
    final screenWidth = constraints.maxWidth;
    final isSmallScreen = screenWidth < 1024;
    final isLargeScreen = screenWidth >= 1024;
    double imageHeight = isSmallScreen
        ? constraints.maxHeight * 0.15
        : constraints.maxHeight * 0.35;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          createPageRoute(
            EditProductPage(productId: product['id']),
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
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
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
            Padding(
              padding: EdgeInsets.all(8.0 * baseTextScale),
              child: isLargeScreen
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                            primary: Colors.red,
                            padding: EdgeInsets.symmetric(
                              vertical: 16.0 * baseTextScale,
                              horizontal: 16.0 * baseTextScale,
                            ),
                          ),
                          onPressed: () => _deleteProduct(
                            product['id'],
                            List<String>.from(product['images']),
                          ),
                          child: Text(
                            'Delete',
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
                          primary: Colors.red,
                        ),
                        onPressed: () => _deleteProduct(
                          product['id'],
                          List<String>.from(product['images']),
                        ),
                        child: Text(
                          'Delete',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text('Manage Products'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _products.isEmpty
              ? Center(child: Text('No products available'))
              : LayoutBuilder(
                  builder: (context, constraints) {
                    final screenWidth = constraints.maxWidth;
                    final isSmallScreen = screenWidth < 600;
                    final double baseTextScale = isSmallScreen ? 0.8 : 1.0;
                    final double childAspectRatio = isSmallScreen
                        ? 0.7
                        : 1.0; // Adjusted for larger screens

                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isSmallScreen ? 2 : 3,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: childAspectRatio,
                        ),
                        itemCount: _products.length,
                        itemBuilder: (context, index) {
                          return _buildProductCard(context, _products[index],
                              baseTextScale, constraints);
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
