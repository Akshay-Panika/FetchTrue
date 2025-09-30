

import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/custom_icon.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:fetchtrue/core/widgets/shimmer_box.dart';
import 'package:fetchtrue/helper/Contact_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class RelationshipManagerCardWidget extends StatelessWidget {
 final ImageProvider<Object>? backgroundImage;
 final double? radius;
 final String? name;
 final String? phone;
 final String? id;
 final String? address;
 final String? level;
 final bool? status;
  const RelationshipManagerCardWidget({super.key, this.backgroundImage, this.name, this.phone, this.id, this.level, this.address, this.radius, this.status});

  @override
  Widget build(BuildContext context) {

    return CustomContainer(
      border: false,
      borderColor: CustomColor.appColor,
      color: Colors.white,
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30, bottom: 15, left: 10, right: 10),
            child: Column(
              children: [
               Row(
                 spacing: 10,
                 crossAxisAlignment: CrossAxisAlignment.start,
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: [
                   CircleAvatar(
                     radius: radius ?? 30,
                     backgroundColor: CustomColor.whiteColor,
                     backgroundImage: backgroundImage,
                   ),

                   Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRow(context, 'ID:', id ?? '#XXXXX'),
                        _buildRow(context, 'Name:', name?? 'Guest'),

                        if(address != null && address != '')
                        Text(address ??'', style: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,)

                      ],
                   )
                 ],
               ),
                Divider(),
                5.height,

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 30,vertical: 5),
                      decoration: BoxDecoration(
                          color: CustomColor.appColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Text('Relationship Manager', style: textStyle12(context, color: CustomColor.appColor),),
                    ),

                    Row(
                      children: [
                        InkWell(
                            onTap: () => ContactHelper.call(phone!),
                            child: Image.asset(CustomIcon.phoneIcon, height: 25,color: CustomColor.appColor,)),
                        35.width,
                        InkWell(
                            onTap: () => ContactHelper.whatsapp(phone!, 'Hello ${name}!'),
                            child: Image.asset(CustomIcon.whatsappIcon, height: 25,color: CustomColor.greenColor,)),
                        10.width,
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          Container(
              decoration: BoxDecoration(
                  color: status == true ? Colors.grey :CustomColor.appColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                )
              ),
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(level!, style: textStyle12(context, color: CustomColor.whiteColor),)),
        ],
      ),
    );
  }
}


Widget _buildRow(BuildContext context ,String key, String value){
  return Row(
    children: [
      Text(key, style: textStyle14(context, fontWeight: FontWeight.w400),),
      10.width,
      Text(value, style: textStyle14(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),
    ],
  );
}


class RelationshipManagerCardShimmer extends StatelessWidget {
  const RelationshipManagerCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      border: false,
      borderColor: CustomColor.appColor,
      color: Colors.white,
      padding: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.only(top: 30, bottom: 15, left: 10, right: 10),
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Column(
            children: [
              Row(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey,),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerBox(width: 100, height: 10),
                      8.height,
                      ShimmerBox(width: 120, height: 10),
                      8.height,
                      ShimmerBox(width: 140, height: 10),
                    ],
                  )
                ],
              ),
              const Divider(),
              10.height,

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ShimmerBox(
                    width: 160,
                    height: 25,
                  ),
                  Row(
                    children: [
                      ShimmerBox(width: 25, height: 25,),
                      30.width,
                      ShimmerBox(width: 25, height: 25,),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
