


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
    return Container(
      color: CustomColor.whiteColor,
      child: Column(
        children: [
          CarouselSlider.builder(
            itemCount: widget.services.first.bannerImages.length,
            itemBuilder:(context, index, realIndex) {
              final bannerCount = widget.services.first.bannerImages[index];
              return CustomContainer(
                width: double.infinity,
                networkImg: widget.services.first.bannerImages[index],
                borderRadius: false,
                margin: EdgeInsets.zero,
              );
            } ,
            options: CarouselOptions(
              height: 200,
              scrollPhysics:widget.services.first.bannerImages.length > 1? AlwaysScrollableScrollPhysics() :NeverScrollableScrollPhysics(),
              autoPlay: widget.services.first.bannerImages.length > 1? true :false,
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

          if(widget.services.first.bannerImages.length >1)
            Column(
              children: [
                10.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(widget.services.first.bannerImages.length, (index) {
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
            ),
          10.height,
        ],
      ),
    );
  }
}
