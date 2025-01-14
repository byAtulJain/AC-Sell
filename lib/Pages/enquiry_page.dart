import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart'; // Add this import for email validation
import '../main.dart';
import 'footer_widget.dart';
import 'login_page.dart';
import 'products.dart';

class EnquiryPage extends StatefulWidget {
  final String? selectedProduct;

  EnquiryPage({this.selectedProduct});

  @override
  _EnquiryPageState createState() => _EnquiryPageState();
}

class _EnquiryPageState extends State<EnquiryPage> {
  String currentPage = 'Enquiry';
  String? selectedProduct;
  String? selectedDuration;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();

  List<Map<String, String>> firebaseProducts = [];
  bool isLoadingProducts = true;
  bool isLoadingRentPeriods = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
    selectedProduct = widget.selectedProduct;
  }

  void fetchProducts() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('sell products').get();

      setState(() {
        firebaseProducts = snapshot.docs.map((doc) {
          final data = doc.data();
          return {
            'id': doc.id,
            'image':
                (data['images'] as List<dynamic>?)?.first?.toString() ?? '',
            'heading': '${data['companyName']} AC ${data['ton']} Ton',
            'price': 'Price: Rs. ${data['price']}',
          };
        }).toList();
        isLoadingProducts = false;
      });
    } catch (e) {
      print('Error fetching products: $e');
      setState(() {
        isLoadingProducts = false;
      });
    }
  }

  Future<void> submitEnquiry() async {
    if (!_validateForm()) {
      print("Please fill all fields correctly!");
      return;
    }

    try {
      // Find the selected product's ID
      final selectedProductId = firebaseProducts
          .firstWhere((product) => product['heading'] == selectedProduct)['id'];

      // Create a reference to the selected product document
      final selectedProductRef = FirebaseFirestore.instance
          .collection('sell products')
          .doc(selectedProductId);

      // Create a new document in the "Rent Enquiry" collection
      await FirebaseFirestore.instance.collection('Sell Enquiry').add({
        'name': nameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'address': addressController.text,
        'pincode': pincodeController.text,
        'selectedProduct': selectedProductRef,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Enquiry submitted successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      print("Enquiry submitted successfully!");
      // Clear the form fields after submission
      nameController.clear();
      emailController.clear();
      phoneController.clear();
      addressController.clear();
      pincodeController.clear();
      setState(() {
        selectedProduct = null;
        selectedDuration = null;
      });
    } catch (e) {
      print('Error submitting enquiry: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double baseTextScale = MediaQuery.of(context).textScaleFactor;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 600;

        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(isSmallScreen ? 50 : 60),
            child: AppBar(
              scrolledUnderElevation: 0,
              automaticallyImplyLeading: false,
              title: Row(
                children: [
                  SizedBox(width: 10),
                  Text(
                    'The AC Sale',
                    style: TextStyle(
                      fontSize: 20 * baseTextScale,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              actions: [
                if (!isSmallScreen) ...[
                  _buildNavButton('Home', baseTextScale, context),
                  _buildNavButton('Products', baseTextScale, context),
                  _buildNavButton('Enquiry', baseTextScale, context),
                  _buildNavButton('Login', baseTextScale, context),
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
                        _buildDrawerItem(Icons.home_outlined, 'Home',
                            baseTextScale, context),
                        _buildDrawerItem(Icons.category_outlined, 'Products',
                            baseTextScale, context),
                        _buildDrawerItem(Icons.contacts_outlined, 'Enquiry',
                            baseTextScale, context),
                        _buildDrawerItem(Icons.login_outlined, 'Login',
                            baseTextScale, context),
                      ],
                    ),
                  ),
                )
              : null,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        'Enquiry Form',
                        style: TextStyle(
                          fontSize: 24 * baseTextScale,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF990011),
                        ),
                      ),
                      SizedBox(height: 20),
                      _buildTextField(
                        controller: nameController,
                        label: "Name",
                        hintText: "Enter your name",
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(height: 20),
                      _buildTextField(
                        controller: emailController,
                        label: "Email",
                        hintText: "Enter your email",
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          } else if (!EmailValidator.validate(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      _buildTextField(
                        controller: phoneController,
                        label: "Phone Number",
                        hintText: "Enter your phone number",
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      _buildTextField(
                        controller: addressController,
                        label: "Address",
                        hintText: "Enter your address",
                        keyboardType: TextInputType.streetAddress,
                      ),
                      SizedBox(height: 20),
                      _buildTextField(
                        controller: pincodeController,
                        label: "Pincode",
                        hintText: "Enter your pincode",
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 20),
                      _buildDropdownField(
                        label: "Select a Product",
                        items: firebaseProducts.map((product) {
                          return DropdownMenuItem<String>(
                            value: product['heading'],
                            child: Row(
                              children: [
                                Image.network(
                                  product['image']!,
                                  height: 40,
                                  width: 40,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.broken_image, size: 40);
                                  },
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    "${product['heading']} (${product['price']})",
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        value: firebaseProducts.any((product) =>
                                product['heading'] == selectedProduct)
                            ? selectedProduct
                            : null,
                        onChanged: (value) {
                          setState(() {
                            selectedProduct = value;
                          });
                        },
                      ),
                      SizedBox(height: 30),
                      Center(
                        child: ElevatedButton(
                          onPressed: submitEnquiry,
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFF990011),
                            padding: EdgeInsets.symmetric(
                              vertical: 16.0,
                              horizontal: 32.0,
                            ),
                          ),
                          child: Text(
                            "Submit",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                AppFooter(),
              ],
            ),
          ),
        );
      },
    );
  }

  // Method to build text field
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required TextInputType keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: validator,
    );
  }

  Widget _buildDropdownField({
    required String label,
    required List<DropdownMenuItem<String>> items,
    required String? value,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
      ),
      isExpanded: true,
      items: items,
      value: value,
      onChanged: onChanged,
    );
  }

  // Form validation
  bool _validateForm() {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty ||
        addressController.text.isEmpty ||
        pincodeController.text.isEmpty ||
        selectedProduct == null) {
      print("Please fill all fields!");
      return false;
    }
    if (!EmailValidator.validate(emailController.text)) {
      print("Please enter a valid email!");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid email!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }
    if (!RegExp(r'^\d{10}$').hasMatch(phoneController.text)) {
      print("Please enter a valid phone number!");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid phone number!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }
    return true;
  }

  Widget _buildNavButton(
      String text, double baseTextScale, BuildContext context) {
    bool isCurrentPage = text == currentPage;
    return TextButton(
      onPressed: () {
        if (text == 'Home') {
          Navigator.pushReplacement(
            context,
            _createPageRoute(HomePage()),
          );
        } else if (text == 'Products') {
          Navigator.pushReplacement(
            context,
            _createPageRoute(ProductsPage()),
          );
        } else if (text == 'Login') {
          Navigator.pushReplacement(
            context,
            _createPageRoute(LoginPage()),
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

  Widget _buildDrawerItem(
      IconData icon, String title, double baseTextScale, BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF990011)),
      title: Text(
        title,
        style: TextStyle(
          color: Color(0xFF990011),
          fontSize: 16 * baseTextScale,
        ),
      ),
      onTap: () {
        Navigator.pop(context); // Close the drawer
        if (title == 'Home') {
          Navigator.pushReplacement(
            context,
            _createPageRoute(HomePage()),
          );
        } else if (title == 'Products') {
          Navigator.pushReplacement(
            context,
            _createPageRoute(ProductsPage()),
          );
        } else if (title == 'Login') {
          Navigator.pushReplacement(
            context,
            _createPageRoute(LoginPage()),
          );
        }
      },
    );
  }

  PageRouteBuilder _createPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = 0.0;
        const end = 1.0;
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var fadeAnimation = animation.drive(tween);

        return FadeTransition(
          opacity: fadeAnimation,
          child: child,
        );
      },
      transitionDuration: Duration(milliseconds: 500),
    );
  }
}
