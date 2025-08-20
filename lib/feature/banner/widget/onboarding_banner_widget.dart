import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_network_mage.dart';
import '../bloc/banner/banner_bloc.dart';
import '../bloc/banner/banner_state.dart';

class OnboardingBannerWidget extends StatefulWidget {
  final String moduleId;
   const OnboardingBannerWidget({super.key, required this.moduleId});

  @override
  State<OnboardingBannerWidget> createState() => _OnboardingBannerWidgetState();
}

class _OnboardingBannerWidgetState extends State<OnboardingBannerWidget> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BannerBloc, BannerState>(
      builder: (context, state) {
        if (state is BannerLoading) {
          return _buildShimmerCard();
        } else if (state is BannerLoaded) {
          // final banners = state.banners;
          final banners = state.banners.where((banner) => banner.module!.id == widget.moduleId).toList();

          if (banners.isEmpty) return const SizedBox.shrink();

          return Column(
            children: [
              SizedBox(height: 180,width: double.infinity,
                child: CarouselSlider.builder(
                  itemCount: banners.length,
                  itemBuilder: (context, index, realIndex) {
                    final banner = banners[index];
                    return CustomNetworkImage(
                      imageUrl: banner.file,
                      fit: BoxFit.fill,
                      margin: EdgeInsets.all(10),
                      borderRadius: BorderRadius.circular(10),
                    );
                    },
                  options: CarouselOptions(
                    scrollPhysics:  banners.length >1 ? AlwaysScrollableScrollPhysics(): NeverScrollableScrollPhysics(),
                    autoPlay:  banners.length >1 ?true :false,
                    viewportFraction: 1,
                    enlargeCenterPage: true,
                    autoPlayInterval: const Duration(seconds: 4),
                    autoPlayCurve: Curves.easeOut,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    },
                  ),
                ),
              ),
               10.height,
              if (banners.length > 1)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(banners.length, (index) {
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
                )
            ],
          );
        } else if (state is BannerError) {
          print('Error ${state.message}');
        }
        return const SizedBox.shrink();
      },
    );
  }
}



Widget _buildShimmerCard(){
  return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: [
          CustomContainer(
              height: 180,width: double.infinity,
              margin: EdgeInsets.zero, color: Colors.grey[200]),
          10.height,

          Row(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(2, (index) => CustomContainer(padding: EdgeInsets.zero,margin: EdgeInsets.zero,height: 5,width: index ==0 ? 25: 10, color: Colors.grey[200]),),)
        ],
      ));
}