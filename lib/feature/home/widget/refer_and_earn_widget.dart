
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
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
      border: false,
      width: double.infinity,
      padding: EdgeInsets.zero,
      color: Colors.white,
      borderRadius: false,
      height: dimensions.screenHeight*0.35,
      margin: EdgeInsets.zero,
      assetsImg: 'assets/image/home_reffrerImg.jpg',
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TeamBuildScreen(),)),
    );
  }
}
