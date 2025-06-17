import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/widgets/custom_bottom_sheet.dart';
import '../../../core/widgets/custom_container.dart';

class FilterWidget extends StatelessWidget {
 final Dimensions dimensions;
  const FilterWidget({super.key, required this.dimensions});

  @override
  Widget build(BuildContext context) {
    return  Row(
      children: [
        Expanded(
          child: Container(
            height: 40,
            color: CustomColor.whiteColor,
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            child: ListView.builder(
              itemCount: 10,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: dimensions.screenWidth*0.02),
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: dimensions.screenWidth*0.03),
                  child: Center(child: Text("Filter $index")),
                );
              },),
          ),
        ),
        CustomContainer(
            height: 40,
            border: true,
            borderRadius: false,
            backgroundColor: Colors.white,
            margin: EdgeInsets.zero,
            // padding: EdgeInsets.zero,
            onTap: () => CustomBottomSheet(context: context, height: 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                  ],
                )),
            child: Center(child: Icon(Icons.menu))),
      ],
    );
  }
}
