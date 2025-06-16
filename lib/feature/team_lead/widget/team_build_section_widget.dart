import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';

class TeamBuildSectionWidget extends StatefulWidget {
  const TeamBuildSectionWidget({super.key});

  @override
  State<TeamBuildSectionWidget> createState() => _TeamBuildSectionWidgetState();
}

class _TeamBuildSectionWidgetState extends State<TeamBuildSectionWidget> {

  bool _isUpgrate = false;

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        50.height,
        /// Illustration or Banner
        CustomContainer(
          height: dimensions.screenHeight*0.2,
          width: double.infinity,
          margin: EdgeInsets.zero,
          assetsImg: CustomImage.inviteImage,
        ),
        20.height,
        Column(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text(
              'Invite Friends & Businesses',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Share your referral code below and\ngrow your team.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.blue),
            ),

            SizedBox(height: 60,),
          ],
        ),



        /// Referral Code Box
        _isUpgrate?
        DottedBorder(
          color: Colors.grey,
          dashPattern: [10, 5],
          borderType: BorderType.RRect,
          radius: Radius.circular(8),
          borderPadding: EdgeInsets.all(10),
          child: Row(
            children: [
              SizedBox(width: 25,),
              Expanded(flex: 2,
                child: TextField(
                  readOnly: true,
                  decoration:  InputDecoration(
                    hintText: 'Akshay0001',
                    hintStyle: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),
                    border: InputBorder.none, // removes all borders
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: CustomContainer(
                    backgroundColor: CustomColor.appColor.withOpacity(0.8),
                    child: Icon(Icons.copy,color: Colors.white,)
                ),
              ),
            ],
          ),
        ):
        CustomContainer(
          border: true,
          height: 100,
          backgroundColor: CustomColor.whiteColor,
          // backgroundColor: CustomColor.appColor.withOpacity(0.1),
          margin: EdgeInsetsDirectional.symmetric(horizontal: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, color: CustomColor.appColor,),
              10.width,
              Text('Upgrade now to start earning', style: textStyle16(context, color: CustomColor.appColor),)
            ],
          ),
        ),

        SizedBox(height: dimensions.screenHeight*0.03),

        /// Upgrade Button
        _isUpgrate ?
        CircleAvatar(
            backgroundColor: Colors.blue.shade50,
            child: IconButton(onPressed: (){}, icon: Icon(Icons.share, color: CustomColor.appColor,))):
        CustomContainer(
          width: 200,
          backgroundColor: CustomColor.appColor,
          onTap: () {
            setState(() {
              _isUpgrate= true;
            });
          },
          child: Center(child:  Text('Upgrade Now', style: textStyle16(context, color: CustomColor.whiteColor))),
        ),
        SizedBox(height: dimensions.screenHeight*0.05),
      ],
    );
  }
}