import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../../feature/banner/model/banner_model.dart';
import 'custom_container.dart';



class CustomBanner extends StatefulWidget {
  final List<ModuleBannerModel> bannerData;
  final double height;
  final void Function(ModuleBannerModel banner) onTap;

  const CustomBanner({super.key, required this.bannerData, required this.height, required this.onTap});

  @override
  State<CustomBanner> createState() => _CustomBannerState();
}

class _CustomBannerState extends State<CustomBanner> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: widget.bannerData.length,
          itemBuilder: (context, index, realIndex) {
            final banner = widget.bannerData[index];
            return CustomContainer(
              networkImg: banner.file,
              onTap: () => widget.onTap.call(banner),
            );
          },
          options: CarouselOptions(
            height: widget.height,
            scrollPhysics:  widget.bannerData.length >1 ? AlwaysScrollableScrollPhysics(): NeverScrollableScrollPhysics(),
            autoPlay:  widget.bannerData.length >1 ?true :false,
            enlargeCenterPage: true,
            viewportFraction: 1,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayCurve: Curves.easeOut,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
        ),

        /// 🔘 Dot indicators
        if(widget.bannerData.length >1)
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(widget.bannerData.length, (index) {
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
