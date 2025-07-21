import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_icon.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../helper/Contact_helper.dart';
import '../model/relationship_manager_model.dart';

class RelationshipManagerCardWidget extends StatelessWidget {
  final RelationshipManagerModel referralUser;
  const RelationshipManagerCardWidget({super.key, required this.referralUser});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      border: true,
      borderColor: CustomColor.appColor,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      backgroundColor: CustomColor.whiteColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Relationship Manager', style: textStyle14(context, fontWeight: FontWeight.w500)),
          10.height,
          Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: CustomColor.greyColor.withOpacity(0.2),
                    backgroundImage: AssetImage(CustomImage.nullImage),
                  ),

                  Positioned(
                      bottom: 0,right: 0,
                      child: Icon(Icons.check_circle, color: Colors.grey,)),
                ],
              ),
              10.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  Text("Name: ${referralUser.fullName}"),
                  Text("Email: ${referralUser.email}"),
                  Text("Mobile: ${referralUser.mobileNumber}"),
                ],
              ),
            ],
          ),
          10.height,

          CustomContainer(
            border: true,
            backgroundColor: CustomColor.whiteColor,
            borderColor: CustomColor.appColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Teams: 00', style: textStyle14(context,fontWeight: FontWeight.w400, color: CustomColor.appColor),),
                Row(
                  children: [
                    InkWell(
                        onTap: () {
                          ContactHelper.call(referralUser.mobileNumber);
                        },
                        child: Image.asset(CustomIcon.phoneIcon, height: 25,color: CustomColor.appColor,)),
                    50.width,
                    InkWell(
                        onTap: () {
                          ContactHelper.whatsapp(referralUser.mobileNumber, 'hello ${referralUser.fullName}');
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
