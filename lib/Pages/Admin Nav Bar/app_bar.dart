import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../../widgets/page_route.dart';
import '../enquiry_page.dart';
import '../home_page.dart';
import '../login_page.dart';
import '../products.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String currentPage;
  final double baseTextScale;
  final bool isAdmin;

  CustomAppBar({
    required this.currentPage,
    required this.baseTextScale,
    this.isAdmin = false,
  });

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return AppBar(
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
          if (isAdmin)
            _buildSignOutButton(baseTextScale, context)
          else
            _buildNavButton('Login', baseTextScale, context),
        ] else
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60);

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

  Widget _buildSignOutButton(double baseTextScale, BuildContext context) {
    return TextButton(
      onPressed: () async {
        try {
          // Sign out from Firebase
          await FirebaseAuth.instance.signOut();

          // Clear login state from SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', false);

          // Navigate to LoginPage
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Sign Out',
            style: TextStyle(
              color: Color(0xFF990011),
              fontWeight: FontWeight.bold,
              fontSize: 16 * baseTextScale,
            ),
          ),
        ],
      ),
    );
  }
}
