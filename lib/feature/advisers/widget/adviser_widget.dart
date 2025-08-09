import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';
import '../screen/adviser_screen.dart';

class AdviserWidget extends StatelessWidget {
  const AdviserWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      height: 200,
      border: true,
      color: Colors.green.shade50,
      width: double.infinity,
      networkImg: 'https://template.canva.com/EAGCux6YcJ8/1/0/1600w-pxaBUxBx9Cg.jpg',
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AdviserScreen())),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, bottom: 15),
          child: Container(
            color: CustomColor.whiteColor,
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('Contact Us', style: textStyle16(context, color: CustomColor.appColor),),
          ),
        ),
      ),
    );
  }
}
