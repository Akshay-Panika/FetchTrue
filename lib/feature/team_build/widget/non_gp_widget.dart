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
  final NonGpModel data;
  const NonGpWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomContainer(
            border: true,
            borderColor: CustomColor.appColor,
            backgroundColor: CustomColor.whiteColor,
            margin: EdgeInsets.only(top: 15),
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
                          backgroundColor: CustomColor.appColor,
                          backgroundImage: AssetImage(CustomImage.nullImage),
                        ),
                        10.width,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${data.fullName}'),
                            Text('${data.referralCode}'),
                          ],
                        ),
                      ],
                    ),


                    CustomContainer(
                      margin: EdgeInsets.zero,
                      child: Text('Earning\nOpportunity\n500',style: textStyle12(context, color: CustomColor.appColor),textAlign: TextAlign.center,),)
                  ],
                ),
                Divider(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(icon: Icon(Icons.check_circle, color: Colors.green,),label: Text('Registration', style: textStyle14(context, fontWeight: FontWeight.w400),),onPressed: () => null,),
                    TextButton.icon(icon: Icon(Icons.check_circle, color: Colors.grey.shade500,),label: Text('Active GP', style: textStyle14(context, fontWeight: FontWeight.w400),),onPressed: () => null,),
                    TextButton.icon(icon: Icon(Icons.check_circle, color: Colors.grey.shade500,),label: Text('KYC', style: textStyle14(context, fontWeight: FontWeight.w400),),onPressed: () => null,),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(' Self Follow Up', style: textStyle16(context,fontWeight: FontWeight.w400, color: CustomColor.appColor),),
                      Row(
                        children: [
                          InkWell(
                              onTap: () {
                                ContactHelper.call(data.mobileNumber);
                              },
                              child: Image.asset(CustomIcon.phoneIcon, height: 25,color: CustomColor.appColor,)),
                          50.width,
                          InkWell(
                              onTap: () {
                                ContactHelper.whatsapp(data.mobileNumber, 'Hello, ${data.fullName}');
                              },
                              child: Image.asset(CustomIcon.whatsappIcon, height: 25,)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
