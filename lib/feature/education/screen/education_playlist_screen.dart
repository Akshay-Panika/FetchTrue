import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:bizbooster2x/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_headline.dart';

class EducationSubcategoryScreen extends StatelessWidget {
  final String headline;
  const EducationSubcategoryScreen({super.key, required this.headline});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return Scaffold(
      appBar: CustomAppBar(title: 'Tutorial', showBackButton: true,),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              10.height,
              Padding(
                padding:  EdgeInsets.symmetric(horizontal:dimensions.screenHeight*0.015),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomContainer(
                      assetsImg: CustomImage.thumbnailImage,
                      height: dimensions.screenHeight*0.22,
                      margin: EdgeInsets.zero,
                      child: Center(child: Icon(Icons.play_circle)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Name', style: textStyle14(context),),
                          Text('Distributions', style: textStyle14(context, fontWeight: FontWeight.w400, color: CustomColor.descriptionColor),),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
          
              CustomHeadline(headline: 'Video List',),
          
              ListView.builder(
              itemCount: 3,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: dimensions.screenWidth*0.03),
              itemBuilder: (context, index) {
                return CustomContainer(
                  border: true,
                  backgroundColor: CustomColor.whiteColor,
                  height: dimensions.screenHeight*0.12,
                  margin: EdgeInsets.only(bottom: dimensions.screenHeight*0.015),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            CustomContainer(
                              width: dimensions.screenWidth*0.35,
                              margin: EdgeInsets.zero,
                              assetsImg: CustomImage.thumbnailImage,
                              child: Center(child: Icon(Icons.lock, color: CustomColor.appColor,size: 30,)),
                            ),
                            10.width,
          
                            Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Name', style: textStyle12(context),),
                                    SizedBox(height: dimensions.screenHeight*0.002,),
                                    Text('Distribution', style: textStyle12(context,color: CustomColor.descriptionColor),),
                                  ],
                                ))
                          ],
                        ),
                      ),
                      Text('Pending', style: textStyle12(context, color: CustomColor.appColor),)
                    ],
                  ),
                );
              },
                          ),

              Padding(
                padding: const EdgeInsets.all(15),
                child: CustomButton(label: 'Enroll Now',onPressed: () => null,),
              )
            ],
          ),
        ),
      ),
    );
  }
}
