import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'custom_container.dart';

class CustomBanner extends StatefulWidget {
  const CustomBanner({super.key});

  @override
  State<CustomBanner> createState() => _CustomBannerState();
}

class _CustomBannerState extends State<CustomBanner> {
  int _current = 0;

  final List<Map<String, String>> bannerData = [
    {
      'image' : 'assets/image/thumbnail1.png'
    },
    {
      'image' : 'assets/image/thumbnail2.png'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 180,
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
                  assetsImg: data['image'],
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
                color: _current == index ? Colors.blueAccent : Colors.grey,
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        ),
      ],
    );
  }
}
