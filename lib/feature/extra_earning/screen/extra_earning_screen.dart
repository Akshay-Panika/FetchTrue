import 'package:fetchtrue/core/costants/custom_icon.dart';
import 'package:fetchtrue/core/costants/custom_image.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:flutter/material.dart';

class ExtraEarningScreen extends StatelessWidget {
  const ExtraEarningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Extra Earning', showBackButton: true,),

      body: SafeArea(
        child: Column(
          children: [
            10.height,

            SizedBox(
              height: 100,
              child: ListView.builder(
                itemCount: 5,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 10),
                itemBuilder: (context, index) {
                  return CustomContainer(
                    width: 100,
                    margin: EdgeInsets.only(right: 10),
                    assetsImg: CustomImage.nullImage,
                  );
                },),
            ),
            10.height,

            Expanded(
              child: ListView.builder(
                itemCount: 5,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return CustomContainer(
                    height: 200,
                    margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                    assetsImg: CustomImage.thumbnailImage,
                  );
                },),
            ),



            
          ],
        ),
      ),
    );
  }
}
