import 'dart:async';
import 'package:ac_buy/widgets/card_section.dart';
import 'package:ac_buy/widgets/customer_review.dart';
import 'package:ac_buy/widgets/page_route.dart';
import 'package:ac_buy/widgets/poster_slider.dart';
import 'package:ac_buy/widgets/product_heading.dart';
import 'package:ac_buy/widgets/why_choose_us.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shimmer/shimmer.dart';
import 'Pages/home_page.dart';
import 'firebase_options.dart';

import 'Pages/enquiry_page.dart';
import 'Pages/footer_widget.dart';
import 'Pages/login_page.dart';
import 'Pages/product_detail_page.dart';
import 'Pages/products.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    DevicePreview(
      enabled: !kReleaseMode, // Set to false in production
      builder: (context) => ACRentalWebsite(),
    ),
  );
}

class ACRentalWebsite extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The AC Sale',
      theme: ThemeData(
        fontFamily: 'Poppins',
        primaryColor: Color(0xFF990011),
        scaffoldBackgroundColor: Color(0xFFFCF6F5),
        appBarTheme: AppBarTheme(
          foregroundColor: Color(0xFF990011),
          backgroundColor: Color(0xFFFCF6F5),
        ),
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Color(0xFF990011)),
          bodyText2: TextStyle(color: Color(0xFF990011)),
          headline6:
              TextStyle(color: Color(0xFF990011), fontWeight: FontWeight.bold),
        ),
      ),
      home: HomePage(),
    );
  }
}
