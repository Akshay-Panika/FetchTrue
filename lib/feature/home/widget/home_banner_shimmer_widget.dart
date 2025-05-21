import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeBannerShimmerWidget extends StatelessWidget {
  const HomeBannerShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: [
          CustomContainer(
            height: 160,
            backgroundColor: CustomColor.whiteColor
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomContainer(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                height: 5,
                width: 24,
                backgroundColor: CustomColor.whiteColor
              ),
              CustomContainer(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                height: 5,
                width: 10,
                  backgroundColor: CustomColor.whiteColor
              ),
            ],
          ),
        ],
      ),
    );
  }
}
