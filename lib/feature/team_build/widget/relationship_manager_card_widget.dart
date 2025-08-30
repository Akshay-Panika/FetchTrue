

import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/custom_icon.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:fetchtrue/helper/Contact_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RelationshipManagerCardWidget extends StatelessWidget {
 final ImageProvider<Object>? backgroundImage;
 final double? radius;
 final String? name;
 final String? phone;
 final String? id;
 final String? address;
 final String? level;
  const RelationshipManagerCardWidget({super.key, this.backgroundImage, this.name, this.phone, this.id, this.level, this.address, this.radius});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      border: true,
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
                        _buildRow(context, 'Name:', name?? 'Guest'),
                        _buildRow(context, 'ID:', id ?? '#XXXXX'),
                         if(address != null && address != '')
                        _buildRow(context, 'Address:', address!),
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
                      child: Text('Self Follow Up', style: textStyle12(context, color: CustomColor.appColor),),
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
                color: CustomColor.appColor,
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