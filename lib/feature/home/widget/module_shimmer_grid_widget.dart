import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/costants/custom_color.dart';
import '../../../core/widgets/custom_container.dart';

class ModuleShimmerGrid extends StatelessWidget {
  const ModuleShimmerGrid({super.key});

  static const _itemCount = 9;          // placeholder tiles

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GridView.builder(
        itemCount: _itemCount,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.11 / 1,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (_, __) => Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
             5.height,
              CustomContainer(
                height: 6,
                width: 80,
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                backgroundColor: CustomColor.whiteColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
