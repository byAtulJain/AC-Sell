import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Import the intl package

import '../Admin Nav Bar/app_bar.dart';
import '../Admin Nav Bar/app_drawer.dart';

class ManageEnquiriesPage extends StatefulWidget {
  @override
  _ManageEnquiriesPageState createState() => _ManageEnquiriesPageState();
}

class _ManageEnquiriesPageState extends State<ManageEnquiriesPage> {
  bool _isLoading = false;

  Future<void> _deleteEnquiry(String enquiryId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('Sell Enquiry')
          .doc(enquiryId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Enquiry deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting enquiry: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<Map<String, dynamic>> _fetchProductDetails(
      DocumentReference productRef) async {
    final productSnapshot = await productRef.get();
    return productSnapshot.data() as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    final double baseTextScale = isSmallScreen ? 0.8 : 1.0;

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text('Manage Enquiries'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Sell Enquiry')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final enquiries = snapshot.data?.docs ?? [];

                  if (enquiries.isEmpty) {
                    return Center(child: Text('No enquiries available'));
                  }

                  return ListView.builder(
                    itemCount: enquiries.length,
                    itemBuilder: (context, index) {
                      final enquiry = enquiries[index];
                      final data = enquiry.data() as Map<String, dynamic>;

                      return FutureBuilder<Map<String, dynamic>>(
                        future: _fetchProductDetails(data['selectedProduct']),
                        builder: (context, productSnapshot) {
                          if (productSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }

                          String errorMessage;
                          if (productSnapshot.hasError) {
                            errorMessage = 'Error: ${productSnapshot.error}';
                          } else if (productSnapshot.data == null) {
                            errorMessage =
                                'Error: Expected a value of type \'Map<String, dynamic>\', but got one of type \'Null\'';
                            // Automatically delete the enquiry if product not found
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _deleteEnquiry(enquiry.id);
                            });
                          } else {
                            errorMessage = '';
                          }

                          final productData = productSnapshot.data;

                          // Format the timestamp
                          final timestamp = data['timestamp'] as Timestamp?;
                          final formattedDate = timestamp != null
                              ? DateFormat('dd MMM yyyy, hh:mm a')
                                  .format(timestamp.toDate())
                              : 'N/A';

                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        data['name'],
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Color(0xFF990011)),
                                        onPressed: () =>
                                            _deleteEnquiry(enquiry.id),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Text('Email: ${data['email']}'),
                                  Text('Phone: ${data['phone']}'),
                                  Text('Address: ${data['address']}'),
                                  Text('Pincode: ${data['pincode']}'),
                                  if (productData != null) ...[
                                    Text(
                                        'Product: ${productData['companyName']} AC ${productData['ton']} Ton'),
                                    Text('Price: Rs. ${productData['price']}'),
                                  ],
                                  SizedBox(height: 8),
                                  Text(
                                    'Submitted on: $formattedDate',
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  if (errorMessage.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        errorMessage,
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
