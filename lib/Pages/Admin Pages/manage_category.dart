import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Admin Nav Bar/app_bar.dart';
import '../Admin Nav Bar/app_drawer.dart';

class ManageCategoriesPage extends StatefulWidget {
  @override
  _ManageCategoriesPageState createState() => _ManageCategoriesPageState();
}

class _ManageCategoriesPageState extends State<ManageCategoriesPage> {
  final TextEditingController _categoryController = TextEditingController();
  bool _isLoading = false;

  Future<void> _addCategory() async {
    if (_categoryController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      try {
        await FirebaseFirestore.instance.collection('sell categories').add({
          'name': _categoryController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Category added successfully!')),
        );

        _categoryController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding category: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteCategory(String categoryId, String categoryName) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Check if the category is used in any product
      final productsSnapshot = await FirebaseFirestore.instance
          .collection('sell products')
          .where('category', isEqualTo: categoryName)
          .get();

      if (productsSnapshot.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Category is used in products and cannot be deleted.')),
        );
      } else {
        await FirebaseFirestore.instance
            .collection('sell categories')
            .doc(categoryId)
            .delete();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Category deleted successfully!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting category: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    final double baseTextScale = isSmallScreen ? 0.8 : 1.0;

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text('Manage Categories'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(
                labelText: 'Category Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _addCategory,
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF990011), // Button color
              ),
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text(
                      'Add Category',
                      style: TextStyle(color: Colors.white), // Text color
                    ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('sell categories')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final categories = snapshot.data?.docs ?? [];

                  return ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return ListTile(
                        title: Text(category['name']),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Color(0xFF990011)),
                          onPressed: () =>
                              _deleteCategory(category.id, category['name']),
                        ),
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

  @override
  void dispose() {
    _categoryController.dispose();
    super.dispose();
  }
}
