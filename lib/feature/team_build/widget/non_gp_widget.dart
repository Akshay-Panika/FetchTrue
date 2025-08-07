import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/helper/Contact_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_icon.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';
import '../model/non_gp_model.dart';

class NonGpWidget extends StatelessWidget {
  const NonGpWidget({super.key,});

  @override
  Widget build(BuildContext context) {
    return  CustomContainer(
      border: true,
      backgroundColor: CustomColor.whiteColor,
      margin: EdgeInsetsGeometry.only(left: 10,right: 10, top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: CustomColor.greyColor.withOpacity(0.2),
                    backgroundImage: AssetImage(CustomImage.nullImage),
                  ),
                  10.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name', style: textStyle14(context, fontWeight: FontWeight.w400),),
                      Text('User Id', style: textStyle14(context, fontWeight: FontWeight.w400),),
                    ],
                  ),
                ],
              ),



              CustomContainer(
                border: true,
                margin: EdgeInsets.zero,
                backgroundColor: CustomColor.whiteColor,
                child: Text('Earning Opportunity ₹ 500',style: textStyle12(context, color: CustomColor.appColor),textAlign: TextAlign.center,),)
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(icon: Icon(Icons.check_circle, color: Colors.green,),label: Text('Registration', style: textStyle12(context, fontWeight: FontWeight.w400),),onPressed: () => null,),
              TextButton.icon(icon: Icon(Icons.check_circle, color: Colors.grey.shade500,),label: Text('Active GP', style: textStyle12(context, fontWeight: FontWeight.w400),),onPressed: () => null,),
              TextButton.icon(icon: Icon(Icons.check_circle, color: Colors.grey.shade500,),label: Text('KYC', style: textStyle12(context, fontWeight: FontWeight.w400),),onPressed: () => null,),
            ],
          ),

          Divider(thickness: 0.4,height: 0,),
          10.height,

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(' Self Follow Up', style: textStyle16(context,fontWeight: FontWeight.w400, color: CustomColor.appColor),),
                Row(
                  children: [
                    InkWell(
                        onTap: () {
                          // ContactHelper.call(data.mobileNumber);
                        },
                        child: Image.asset(CustomIcon.phoneIcon, height: 25,color: CustomColor.appColor,)),
                    50.width,
                    InkWell(
                        onTap: () {
                          // ContactHelper.whatsapp(, 'Hello, UserId');
                        },
                        child: Image.asset(CustomIcon.whatsappIcon, height: 25,)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
