import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_icon.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';

class MyLeaderCardWidget extends StatelessWidget {
  const MyLeaderCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomContainer(
          border: true,
          backgroundColor: CustomColor.whiteColor,
          child: Column(
            children: [

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(CustomImage.nullImage),
                    radius: 35,backgroundColor: CustomColor.whiteColor,),
                  10.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Franchise Head Name', style: textStyle14(context),),
                      Text('rank :', style: textStyle14(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),
                      Text('other :', style: textStyle14(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),
                    ],
                  ),
                ],
              ),

              CustomContainer(
                border: true,
                backgroundColor: CustomColor.whiteColor,
                borderColor: CustomColor.appColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Leads : 203', style: textStyle14(context,fontWeight: FontWeight.w400, color: CustomColor.appColor),),
                    Row(
                      children: [
                        Image.asset(CustomIcon.phoneIcon, height: 25,color: CustomColor.appColor,),
                        50.width,
                        Image.asset(CustomIcon.whatsappIcon, height: 25,),
                      ],
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),

      ],
    );
  }
}
