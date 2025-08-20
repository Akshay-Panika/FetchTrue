import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:flutter/material.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/widgets/custom_bottom_sheet.dart';
import '../../../core/widgets/custom_container.dart';

class FilterWidget extends StatelessWidget {
  final Dimensions dimensions;

  FilterWidget({super.key, required this.dimensions});

  final List<String> serviceOptions = [
    'All',
    'Low Price',
    'High Price',
    'Discounted',
    'Most Popular',
    'Newest First',
    'Oldest First',
    'Top Rated',
    'Low to High',
    'High to Low',
    'Best Seller',
    'Recommended',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColor.whiteColor,
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      child: Row(
        children: [
          // Scrollable Filter Options
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 10,
                children: List.generate(
                  serviceOptions.length,
                      (index) => CustomContainer(
                         color: CustomColor.appColor.withOpacity(0.05),
                        margin: EdgeInsets.zero, padding: EdgeInsetsGeometry.symmetric(horizontal: 10,vertical: 5),
                    child: Center(
                      child: Text(serviceOptions[index],style: textStyle12(context),),
                    ),
                  ),
                ),
              ),
            ),
          ),
          10.width,

          // Menu Button
          InkWell(
            child: const Icon(Icons.menu, size: 28),
          )
        ],
      ),
    );
  }
}
