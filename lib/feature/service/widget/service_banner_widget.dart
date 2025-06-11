


import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/costants/custom_color.dart';
import '../../../core/widgets/custom_container.dart';
import '../model/service_model.dart';

class ServiceBannerWidget extends StatefulWidget {
  final List<ServiceModel> services;
  const ServiceBannerWidget({super.key, required this.services});

  @override
  State<ServiceBannerWidget> createState() => _ServiceBannerWidgetState();
}

class _ServiceBannerWidgetState extends State<ServiceBannerWidget> {
  int _current = 0;
  @override
  Widget build(BuildContext context) {

    final service = widget.services.first;

    /// Merge thumbnailImage with bannerImages
    final List<String> mergedImages = [
      if (service.thumbnailImage != null && service.thumbnailImage!.isNotEmpty)
        service.thumbnailImage!,
      ...service.bannerImages
    ];

    return Container(
      color: CustomColor.whiteColor,
      child: Column(
        children: [
          CarouselSlider.builder(
            itemCount: mergedImages.length,
            itemBuilder:(context, index, realIndex) {
              return CustomContainer(
                width: double.infinity,
                networkImg: mergedImages[index],
                borderRadius: false,
                margin: EdgeInsets.zero,
              );
            } ,
            options: CarouselOptions(
              height: 200,
              scrollPhysics: mergedImages.length > 1
                  ? const AlwaysScrollableScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              autoPlay: mergedImages.length > 1,
              enlargeCenterPage: true,
              viewportFraction: 1,
              autoPlayInterval: const Duration(seconds: 4),
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              },
            ),
          ),

          if (mergedImages.length > 1)
            Column(
              children: [
                10.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(mergedImages.length, (index) {
                    final isActive = _current == index;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      height: 5,
                      width: _current == index ? 24 : 10,
                      decoration: BoxDecoration(
                        color: isActive ? Colors.blueAccent : Colors.grey,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    );
                  }),
                ),
              ],
            ),
          10.height,
        ],
      ),
    );
  }
}
