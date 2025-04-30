import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../../../core/widgets/custom_container.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({super.key});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
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
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 150,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 1,
            autoPlayInterval: const Duration(seconds: 4),
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
          items: bannerData.map((data) {
            return Builder(
              builder: (BuildContext context) {
                return CustomContainer(
                  width: double.infinity,
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
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }).toList(),
        ),


        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(bannerData.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              height: 5,
              width: _current == index ? 24 : 10,
              decoration: BoxDecoration(
                color: _current == index ? Colors.blue.shade200 : Colors.grey,
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        ),
      ],
    );
  }
}
