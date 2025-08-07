import 'package:fetchtrue/core/costants/custom_image.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:flutter/material.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_icon.dart';
import '../../../helper/Contact_helper.dart';
import '../model/referred_user_model.dart';

class FirstRelationshipManagerCardWidget extends StatelessWidget {
  final ReferredUser? referredUser;
  const FirstRelationshipManagerCardWidget({super.key, required this.referredUser});

  @override
  Widget build(BuildContext context) {
    if (referredUser == null) return const SizedBox();

    return CustomContainer(
      border: true,
      backgroundColor: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Relationship Manager', style: textStyle14(context),),
          10.height,
          Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(CustomImage.nullImage),
                radius: 30, backgroundColor: Colors.grey[100],),
              15.width,

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name : ${referredUser!.fullName}'),
                  Text('Mobile : ${referredUser!.mobileNumber}'),
                  Text('Email : ${referredUser!.email}'),
                ],
              ),
            ],
          ),
          Divider(thickness: 0.4,),
          CustomContainer(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(' Self Follow Up', style: textStyle16(context,fontWeight: FontWeight.w400, color: CustomColor.appColor),),
                Row(
                  children: [
                    InkWell(
                        onTap: () {
                          ContactHelper.call(referredUser!.mobileNumber);
                        },
                        child: Image.asset(CustomIcon.phoneIcon, height: 25,color: CustomColor.appColor,)),
                    50.width,
                    InkWell(
                        onTap: () {
                          ContactHelper.whatsapp(referredUser!.mobileNumber, 'Hello, ${referredUser!.fullName}');
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
