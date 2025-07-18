import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/custom_image.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:flutter/material.dart';

import 'add_address_screen.dart';
import 'additional_details_screen.dart';
import 'financial_details_screen.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(title: 'Profile', showBackButton: true,),

      body: Stack(
        alignment: AlignmentDirectional.topStart,
        children: [
          Container(
            height: 280,
            color: Colors.grey,
            width: double.infinity,
            child: Image.asset(CustomImage.nullImage,fit: BoxFit.fill,),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 250.0, left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomContainer(
                  border: true,
                  backgroundColor: Colors.white,
                  margin: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Personal Details', style: textStyle16(context),),
                          
                          Row(
                            children: [
                              IconButton(onPressed: () => null, icon: Icon(Icons.mode_edit_outline_outlined)),
                              IconButton(onPressed: () => null, icon: Icon(Icons.camera_alt_outlined)),
                            ],
                          )
                        ],
                      ),
                      10.height,

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Akshay Panika', style: textStyle18(context),),
                              Text('+91 8989207770', style: textStyle14(context, color: CustomColor.descriptionColor),),
                              Text('Email Id', style: textStyle14(context, color: CustomColor.descriptionColor),),
                          
                            ],
                          ),
                          
                          CustomContainer(
                            border: true,
                            backgroundColor: CustomColor.whiteColor,
                            margin: EdgeInsets.zero,
                            child: Text('KYC', style: textStyle14(context,color: CustomColor.appColor),),padding: EdgeInsetsGeometry.symmetric(horizontal: 30,vertical: 5),)
                        ],
                      )
                    ],
                  ),
                ),
                10.height,

                CustomContainer(
                  border: true,
                  backgroundColor: CustomColor.whiteColor,
                  margin: EdgeInsets.zero,
                  child: ListTile(
                    minVerticalPadding: 0,
                    minTileHeight: 0,
                    contentPadding: EdgeInsets.all(0),
                    title: Text('Additional Details'),
                    subtitle: Text('Age, gender, and more'),
                    trailing: Icon(Icons.arrow_forward_ios,size: 20,),
                  ),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AdditionalDetailsScreen(),)),
                ),
                10.height,

                CustomContainer(
                  border: true,
                  backgroundColor: CustomColor.whiteColor,
                  margin: EdgeInsets.zero,
                  child: ListTile(
                    minVerticalPadding: 0,
                    minTileHeight: 0,
                    contentPadding: EdgeInsets.all(0),
                    title: Text('Financial Details'),
                    subtitle: Text('Income, employment details and more'),
                    trailing: Icon(Icons.arrow_forward_ios,size: 20,),
                  ),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FinancialDetailsScreen(),)),
                ),
                10.height,

                Text('Save Addresses', style: textStyle14(context),),
                5.height,
                CustomContainer(
                  border: true,
                  backgroundColor: CustomColor.whiteColor,
                  margin: EdgeInsets.zero,
                  padding: EdgeInsetsGeometry.symmetric(horizontal: 30,vertical: 10),
                  child: Column(
                    children: [
                      Icon(Icons.add),
                      Text('Add New')
                    ],
                  ),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddAddressScreen(),)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
