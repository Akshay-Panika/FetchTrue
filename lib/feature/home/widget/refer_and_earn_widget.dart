
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/costants/custom_color.dart';
import '../../../core/widgets/custom_container.dart';
import '../../team_build/screen/team_build_screen.dart';

class ReferAndEarnWidget extends StatelessWidget {
  const ReferAndEarnWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return  CustomContainer(
      width: double.infinity,
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: dimensions.screenHeight * 0.02,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Your Fetch True', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: CustomColor.appColor),),
              5.height,
              Text('Your friend are going to love us tool', style: TextStyle(fontSize: 14),),
              5.height,
              Text('Refer And Win up to ____', style: TextStyle(fontSize: 16, color: CustomColor.iconColor, fontWeight: FontWeight.w600),),
            ],
          ),

          Image.asset('assets/image/inviteFrnd.png', height: 200, width: double.infinity,)
        ],
      ),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TeamBuildScreen(userId: '',),)),
    );
  }
}
