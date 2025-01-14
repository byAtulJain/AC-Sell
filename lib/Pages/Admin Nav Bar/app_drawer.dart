import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../../widgets/page_route.dart';
import '../enquiry_page.dart';
import '../login_page.dart';
import '../products.dart';

class CustomDrawer extends StatelessWidget {
  final String currentPage;
  final double baseTextScale;
  final bool isAdmin;

  CustomDrawer({
    required this.currentPage,
    required this.baseTextScale,
    this.isAdmin = false,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildDrawerItem(
                Icons.home_outlined, 'Home', baseTextScale, context),
            _buildDrawerItem(
                Icons.category_outlined, 'Products', baseTextScale, context),
            _buildDrawerItem(
                Icons.contacts_outlined, 'Enquiry', baseTextScale, context),
            if (isAdmin)
              _buildSignOutDrawerItem(baseTextScale, context)
            else
              _buildDrawerItem(
                  Icons.login_outlined, 'Login', baseTextScale, context),
          ],
        ),
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
        } else if (title == 'Login') {
          Navigator.pushReplacement(
            context,
            createPageRoute(LoginPage()),
          );
        }
      },
    );
  }

  Widget _buildSignOutDrawerItem(double baseTextScale, BuildContext context) {
    return ListTile(
      leading: Icon(Icons.logout, color: Color(0xFF990011)),
      title: Text(
        'Sign Out',
        style: TextStyle(
          color: Color(0xFF990011),
          fontSize: 16 * baseTextScale,
        ),
      ),
      onTap: () async {
        try {
          // Sign out from Firebase
          await FirebaseAuth.instance.signOut();

          // Clear login state from SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', false);

          // Close the drawer and navigate to LoginPage
          Navigator.pop(context); // Close the drawer
          Navigator.pushReplacement(
            context,
            createPageRoute(LoginPage()),
          );

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Successfully signed out!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        } catch (e) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error signing out: $e'),
            ),
          );
        }
      },
    );
  }
}
