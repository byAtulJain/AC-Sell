import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import '../widgets/page_route.dart';
import 'Admin Pages/add_product.dart';
import 'Admin Pages/admin_dashboard.dart';
import 'home_page.dart';
import 'products.dart';
import 'enquiry_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final String currentPage = 'Login'; // Set the current page
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkLoginState();
  }

  Future<void> _checkLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      // If logged in, navigate to AdminHomePage
      Navigator.pushReplacement(
        context,
        createPageRoute(AdminDashboardPage()),
      );
    }
  }

  Future<void> _login(BuildContext context) async {
    try {
      final auth = FirebaseAuth.instance;
      final userCredential = await auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Save login state in shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully logged in!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      // Navigate to Admin Home Page
      Navigator.pushReplacement(
        context,
        createPageRoute(AdminDashboardPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid Credentials'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 24 * baseTextScale,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF990011),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: isSmallScreen ? screenWidth * 0.8 : 400,
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        prefixIcon: Icon(Icons.email, color: Color(0xFF990011)),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    width: isSmallScreen ? screenWidth * 0.8 : 400,
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        prefixIcon: Icon(Icons.lock, color: Color(0xFF990011)),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF990011),
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    onPressed: () => _login(context),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 16 * baseTextScale,
                        color: Colors.white,
                      ),
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

  Widget _buildNavButton(
      String text, double baseTextScale, BuildContext context) {
    bool isCurrentPage = text == currentPage;
    return TextButton(
      onPressed: () {
        if (text == 'Home') {
          Navigator.pushReplacement(
            context,
            createPageRoute(HomePage()),
          );
        } else if (text == 'Products') {
          Navigator.pushReplacement(
            context,
            createPageRoute(ProductsPage()),
          );
        } else if (text == 'Enquiry') {
          Navigator.pushReplacement(
            context,
            createPageRoute(EnquiryPage()),
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
            createPageRoute(HomePage()),
          );
        } else if (title == 'Products') {
          Navigator.pushReplacement(
            context,
            createPageRoute(ProductsPage()),
          );
        } else if (title == 'Enquiry') {
          Navigator.pushReplacement(
            context,
            createPageRoute(EnquiryPage()),
          );
        }
      },
    );
  }
}
