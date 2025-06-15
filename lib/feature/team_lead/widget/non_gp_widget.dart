import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:bizbooster2x/core/costants/text_style.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/costants/custom_icon.dart';
import '../../../core/costants/custom_image.dart';

class NonGpWidget extends StatelessWidget {
  const NonGpWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0,left: 15),
          child: Text('inactive Team - 354', style: textStyle16(context, fontWeight: FontWeight.w400),),
        ),


        Expanded(
          child: ListView.builder(
            itemCount: 5,
            padding: EdgeInsets.symmetric(horizontal: 10),
            itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomContainer(
                  border: true,
                  backgroundColor: CupertinoColors.activeBlue.withOpacity(0.05),
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
                                  Text('Name'),
                                  Text('Franchise code'),
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
                )
              ],
            );
          },),
        ),
      ],
    );
  }
}
