import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html; // Add this for web support
import 'Footer/BlogPage.dart';
import 'Footer/FAQsPage.dart';
import 'Footer/PrivacyPolicyPage.dart';
import 'Footer/RefundPolicyPage.dart';
import 'Footer/SupportPage.dart';
import 'Footer/TermsAndConditionsPage.dart';

class AppFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isSmallScreen = screenWidth < 600;

        return Container(
          color: Color(0xFF990011),
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: Column(
            crossAxisAlignment: isSmallScreen
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              // Top Section: Links (Responsive Layout)
              if (isSmallScreen) ...[
                Row(
                  children: [
                    Expanded(
                      child: _buildFooterColumn(
                        title: 'Pages',
                        links: ['Home', 'Products', 'Enquiry', 'Login'],
                        context: context,
                      ),
                    ),
                    Expanded(
                      child: _buildFooterColumn(
                        title: 'Terms & Policies',
                        links: [
                          'Terms & Conditions',
                          'Privacy Policy',
                          'Refund Policy'
                        ],
                        context: context,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: _buildFooterColumn(
                        title: 'Resources',
                        links: ['FAQs', 'Support', 'Blog'],
                        context: context,
                      ),
                    ),
                    Expanded(
                      child: _buildFooterColumn(
                        title: 'Contact Us',
                        links: [
                          'Email: theacsale4@gmail.com',
                          'Phone: +91 9301778661',
                          'Address: 43 Ramchandra nagar extension, Indore',
                        ],
                        context: context,
                      ),
                    ),
                  ],
                ),
              ] else ...[
                // Big Screen Layout - Updated for better alignment
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFooterColumn(
                      title: 'Pages',
                      links: ['Home', 'Products', 'Enquiry', 'Login'],
                      context: context,
                      width: 200, // Fixed column width for alignment
                    ),
                    SizedBox(width: 32.0), // Spacing between columns
                    _buildFooterColumn(
                      title: 'Terms & Policies',
                      links: [
                        'Terms & Conditions',
                        'Privacy Policy',
                        'Refund Policy'
                      ],
                      context: context,
                      width: 200,
                    ),
                    SizedBox(width: 32.0),
                    _buildFooterColumn(
                      title: 'Resources',
                      links: ['FAQs', 'Support', 'Blog'],
                      context: context,
                      width: 200,
                    ),
                    SizedBox(width: 32.0),
                    _buildFooterColumn(
                      title: 'Contact Us',
                      links: [
                        'Email: theacsale4@gmail.com',
                        'Phone: +91 9301778661',
                        'Address: 43 Ramchandra nagar extension, Indore',
                      ],
                      context: context,
                      width: 200,
                    ),
                  ],
                ),
              ],
              SizedBox(height: 24.0),
              // Divider Line
              Divider(
                color: Colors.white.withOpacity(0.5),
                thickness: 1.0,
              ),
              SizedBox(height: 16.0),
              // Bottom Section: Copyright and Social Media
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildCopyrightText(isSmallScreen: isSmallScreen),
                  SizedBox(height: 16.0),
                  _buildSocialMediaIcons(),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFooterColumn({
    required String title,
    required List<String> links,
    required BuildContext context,
    double? width,
  }) {
    return SizedBox(
      width: width ?? MediaQuery.of(context).size.width / 2 - 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.0),
          ...links.map((link) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: GestureDetector(
                onTap: () {
                  _handleNavigation(link, context);
                },
                child: Text(
                  link,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  void _handleNavigation(String link, BuildContext context) {
    if (link == 'Terms & Conditions') {
      Navigator.push(
        context,
        _createPageRoute(TermsAndConditionsPage()),
      );
    } else if (link == 'Privacy Policy') {
      Navigator.push(
        context,
        _createPageRoute(PrivacyPolicyPage()),
      );
    } else if (link == 'Refund Policy') {
      Navigator.push(
        context,
        _createPageRoute(RefundPolicyPage()),
      );
    } else if (link == 'FAQs') {
      Navigator.push(
        context,
        _createPageRoute(FAQsPage()),
      );
    } else if (link == 'Support') {
      Navigator.push(
        context,
        _createPageRoute(SupportPage()),
      );
    } else if (link == 'Blog') {
      Navigator.push(
        context,
        _createPageRoute(BlogPage()),
      );
    } else {
      print('$link tapped');
    }
  }

  Widget _buildCopyrightText({required bool isSmallScreen}) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '© 2025 The AC Sale. All Rights Reserved.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isSmallScreen ? 12 : 14,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          Text(
            'Made with ❤️ by Atul Jain\n(atuljain3003@gmail.com)',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isSmallScreen ? 12 : 14,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialMediaIcons() {
    final List<Map<String, String>> socialMedia = [
      {
        'icon': 'https://img.icons8.com/ios-filled/50/ffffff/facebook.png',
        'link': 'https://www.facebook.com/profile.php?id=61570457416123',
      },
      {
        'icon': 'https://img.icons8.com/ios-filled/50/ffffff/instagram-new.png',
        'link':
            'https://www.instagram.com/theaconrent?igsh=MXRxam0yMXB1YzRybg==',
      },
      {
        'icon':
            'https://s3.ap-southeast-1.amazonaws.com/s3.privyr.com/assets/integrations/JustDial+Logo.png',
        'link': 'https://jsdl.in/RSL-GBD1737286926',
      },
      {
        'icon':
            'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/768px-Google_%22G%22_logo.svg.png',
        'link': 'https://g.co/kgs/7FRRttH',
      },
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: socialMedia.map((platform) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: GestureDetector(
            onTap: () async {
              final url = platform['link']!;
              if (kIsWeb) {
                // Use JavaScript to open the link in a new tab for Flutter Web
                html.window.open(url, '_blank');
              } else {
                // Use url_launcher for other platforms
                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(Uri.parse(url),
                      mode: LaunchMode.externalApplication);
                } else {
                  print('Could not launch $url');
                }
              }
            },
            child: Image.network(
              platform['icon']!,
              height: 24,
              width: 24,
            ),
          ),
        );
      }).toList(),
    );
  }
}

PageRouteBuilder _createPageRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = 0.0;
      const end = 1.0;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var fadeAnimation = animation.drive(tween);

      return FadeTransition(
        opacity: fadeAnimation,
        child: child,
      );
    },
    transitionDuration: Duration(milliseconds: 500), // Adjust duration
  );
}
