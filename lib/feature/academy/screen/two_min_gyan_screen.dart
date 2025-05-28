import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TwoMinGyanScreen extends StatelessWidget {
  const TwoMinGyanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: CustomAppBar(title: '2 Min Gyan', showBackButton: true,),

      body: PageView.builder(
          itemCount: 5,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return CustomContainer(
            borderRadius: false,
            backgroundColor: Colors.black,
            margin: EdgeInsets.zero,
              child: Icon(Icons.play_circle,color: CustomColor.whiteColor, size: 50,),
            );
          },),
    );
  }
}
