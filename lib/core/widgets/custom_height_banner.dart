import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'custom_container.dart';
import 'custom_headline.dart';

class CustomHeightBanner extends StatefulWidget {
  const CustomHeightBanner({super.key});

  @override
  State<CustomHeightBanner> createState() => _CustomHeightBannerState();
}

class _CustomHeightBannerState extends State<CustomHeightBanner> {
  int _current = 0;

  final List<Map<String, String>> bannerData = [
    {
      'title': 'Welcome Back!',
      'subtitle': 'Check your daily summary below.',
    },
    {
      'title': 'Best Franchise',
      'subtitle': 'Track your Franchise progress.',
    },
    {
      'title': 'Popular Franchise',
      'subtitle': 'View Popular Franchise.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColor.appColor.withOpacity(0.08),
      // color: Colors.teal.withOpacity(0.1),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomHeadline(headline: 'Just For You',),

          CarouselSlider(
            options: CarouselOptions(
              height: 200,
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 0.75, // Show part of left & right cards
              padEnds: false,          // Prevent padding at start/end
              autoPlayInterval: const Duration(seconds: 5),
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              },
            ),
            items: bannerData.map((data) {
              return CustomContainer(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                backgroundColor: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      data['title'] ?? '',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      data['subtitle'] ?? '',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
