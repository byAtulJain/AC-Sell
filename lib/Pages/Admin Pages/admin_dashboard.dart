import 'package:flutter/material.dart';

import '../../widgets/page_route.dart';
import '../Admin Nav Bar/app_bar.dart';
import '../Admin Nav Bar/app_drawer.dart';
import 'add_product.dart';
import 'manage_enquiry.dart';
import 'manage_category.dart';
import 'manage_products.dart';

class AdminDashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    final double baseTextScale = isSmallScreen ? 0.8 : 1.0;

    return Scaffold(
      appBar: CustomAppBar(
          currentPage: 'Admin Dashboard',
          baseTextScale: baseTextScale,
          isAdmin: true),
      endDrawer: isSmallScreen
          ? CustomDrawer(
              currentPage: 'Admin Dashboard',
              baseTextScale: baseTextScale,
              isAdmin: true)
          : null,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: isSmallScreen ? 1 : 3,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            _buildDashboardBox(
              context,
              icon: Icons.add,
              label: 'Add Products',
              onTap: () {
                Navigator.push(
                  context,
                  createPageRoute(AddProductPage()),
                );
              },
            ),
            _buildDashboardBox(
              context,
              icon: Icons.edit,
              label: 'Delete & Edit Products',
              onTap: () {
                Navigator.push(
                  context,
                  createPageRoute(ManageProductsPage()),
                );
              },
            ),
            _buildDashboardBox(
              context,
              icon: Icons.message,
              label: 'See & Delete User Enquiry',
              onTap: () {
                Navigator.push(
                  context,
                  createPageRoute(ManageEnquiriesPage()),
                );
              },
            ),
            _buildDashboardBox(
              context,
              icon: Icons.category,
              label: 'Add & Delete Category',
              onTap: () {
                Navigator.push(
                  context,
                  createPageRoute(ManageCategoriesPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardBox(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Color(0xFF990011)),
            SizedBox(height: 16),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
