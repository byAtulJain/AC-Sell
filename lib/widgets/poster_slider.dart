import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';

Widget buildCarouselSlider(
    BuildContext context, double baseTextScale, BoxConstraints constraints) {
  final List<String> smallScreenImgList = [
    'images/Poster/small_screen_poster_1.png',
    'images/Poster/small_screen_poster_2.png',
    'images/Poster/small_screen_poster_3.png',
  ];

  final List<String> largeScreenImgList = [
    'images/Poster/large_screen_poster_1.png',
    'images/Poster/large_screen_poster_2.png',
    'images/Poster/large_screen_poster_3.png',
  ];

  final screenWidth = constraints.maxWidth;
  final isSmallScreen = screenWidth < 600;
  final isMediumScreen = screenWidth >= 600 && screenWidth < 1024;
  final isLargeScreen = screenWidth >= 1024;

  // Choose image list based on screen size
  final List<String> imgList =
      isSmallScreen ? smallScreenImgList : largeScreenImgList;

  // Dynamic slider height based on screen size
  double sliderHeight;
  if (isSmallScreen) {
    sliderHeight = constraints.maxHeight * 0.4;
  } else if (isMediumScreen) {
    sliderHeight = constraints.maxHeight * 0.6;
  } else {
    sliderHeight = constraints.maxHeight * 0.8;
  }

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: CarouselSlider(
        options: CarouselOptions(
          height: sliderHeight,
          viewportFraction: 1.0,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 3),
        ),
        items: imgList.map((item) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(item),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    ),
  );
}
