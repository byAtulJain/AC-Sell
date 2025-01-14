import 'package:flutter/cupertino.dart';

Widget buildProductsHeading(double baseTextScale) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'Our AC Products',
        style: TextStyle(
          fontSize: 24 * baseTextScale,
          fontWeight: FontWeight.bold,
          color: Color(0xFF990011),
        ),
      ),
    ),
  );
}
