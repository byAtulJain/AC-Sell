import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:html' as html;

import '../Admin Nav Bar/app_bar.dart';
import '../Admin Nav Bar/app_drawer.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  List<html.File> _selectedImages = [];
  List<String> _uploadedImageUrls = [];

  final TextEditingController _priceController = TextEditingController();
  String? _selectedCategory;
  String? _selectedStarRating;
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _areaCoveredController = TextEditingController();
  final TextEditingController _tonController = TextEditingController();

  List<Map<String, dynamic>> _categories = [];
  bool _isLoadingCategories = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('sell categories').get();
      setState(() {
        _categories = snapshot.docs
            .map((doc) => {'id': doc.id, 'name': doc['name']})
            .toList();
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

  Future<void> _uploadData() async {
    if (_formKey.currentState!.validate() && _selectedImages.isNotEmpty) {
      try {
        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(child: CircularProgressIndicator()),
        );

        // Upload images first
        _uploadedImageUrls = await _uploadImages();

        // Find the selected category's name
        final selectedCategoryName = _categories.firstWhere(
            (category) => category['id'] == _selectedCategory)['name'];

        final newCardData = {
          'category': selectedCategoryName, // Use the category name
          'price': _priceController.text,
          'starRating': _selectedStarRating,
          'companyName': _companyNameController.text,
          'areaCovered': _areaCoveredController.text,
          'ton': _tonController.text,
          'images': _uploadedImageUrls,
          'timestamp': FieldValue.serverTimestamp(), // Add timestamp
        };

        await FirebaseFirestore.instance
            .collection('sell products')
            .add(newCardData);
        print("Data uploaded successfully");

        // Close loading indicator
        Navigator.of(context).pop();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product added successfully!')),
        );

        // Clear all fields after successful upload
        setState(() {
          _priceController.clear();
          _selectedCategory = null;
          _selectedStarRating = null;
          _companyNameController.clear();
          _areaCoveredController.clear();
          _tonController.clear();
          _selectedImages.clear();
          _uploadedImageUrls.clear();
        });
      } catch (e) {
        // Close loading indicator
        Navigator.of(context).pop();

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading data: $e')),
        );
      }
    }
  }

  Future<List<String>> _uploadImages() async {
    List<String> imageUrls = [];
    for (html.File image in _selectedImages) {
      String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference ref =
          FirebaseStorage.instance.ref().child('products/$fileName');
      final uploadTask = ref.putBlob(image);
      final snapshot = await uploadTask.whenComplete(() {});
      String downloadUrl = await snapshot.ref.getDownloadURL();
      imageUrls.add(downloadUrl);
    }
    return imageUrls;
  }

  Future<void> _pickImages() async {
    final html.FileUploadInputElement uploadInput =
        html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.multiple = true;
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files != null && files.isNotEmpty) {
        setState(() {
          _selectedImages.addAll(files);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    final double baseTextScale = isSmallScreen ? 0.8 : 1.0;

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text('Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 16),
              // Image Selection Section
              Container(
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _selectedImages.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton.icon(
                              onPressed: _pickImages,
                              icon: Icon(Icons.add_photo_alternate),
                              label: Text('Add Images from Gallery'),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _selectedImages.length,
                        itemBuilder: (context, index) {
                          final reader = html.FileReader();
                          reader.readAsDataUrl(_selectedImages[index]);
                          return FutureBuilder(
                            future: reader.onLoad.first,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return Stack(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Image.network(
                                        reader.result as String,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: IconButton(
                                        icon: Icon(Icons.remove_circle,
                                            color: Colors.red),
                                        onPressed: () {
                                          setState(() {
                                            _selectedImages.removeAt(index);
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                            },
                          );
                        },
                      ),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: _isLoadingCategories
                    ? null
                    : _categories
                        .map<DropdownMenuItem<String>>(
                            (category) => DropdownMenuItem<String>(
                                  value: category['id'] as String,
                                  child: Text(category['name'] as String),
                                ))
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category';
                  }
                  return null;
                },
                hint: _isLoadingCategories
                    ? Text('Loading categories...')
                    : Text('Select a category'),
              ),

              SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedStarRating,
                decoration: InputDecoration(
                  labelText: 'Star Rating',
                  border: OutlineInputBorder(),
                ),
                items: ['1', '2', '3', '4', '5']
                    .map((rating) => DropdownMenuItem(
                          value: rating,
                          child: Text(rating),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStarRating = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a star rating';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _companyNameController,
                decoration: InputDecoration(
                  labelText: 'Company Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a company name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _areaCoveredController,
                decoration: InputDecoration(
                  labelText: 'Area Covered (sq. ft.)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the area covered';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _tonController,
                decoration: InputDecoration(
                  labelText: 'Ton',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the ton';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: _uploadData,
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF990011), // Set the button color
                    ),
                    child: Text(
                      'Upload',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _priceController.dispose();
    _companyNameController.dispose();
    _areaCoveredController.dispose();
    _tonController.dispose();
    super.dispose();
  }
}
