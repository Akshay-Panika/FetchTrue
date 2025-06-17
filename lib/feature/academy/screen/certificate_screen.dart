import 'package:fetchtrue/feature/academy/screen/play_video_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';

class CertificateScreen extends StatelessWidget {
  const CertificateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return Scaffold(
      appBar: CustomAppBar(title: 'Certificate', showBackButton: true,),

      body: SafeArea(
        child: ListView.builder(
             itemCount: 4,
            padding: EdgeInsets.symmetric(horizontal: dimensions.screenWidth*0.03),
            itemBuilder: (context, index) {
               int video = 1+index;
              return CustomContainer(
                border: true,
                backgroundColor: CustomColor.whiteColor,
                padding: EdgeInsets.zero,
                margin: EdgeInsets.only(top: dimensions.screenHeight*0.015),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomContainer(
                     assetsImg: CustomImage.thumbnailImage,
                      height: dimensions.screenHeight*0.18,
                      margin: EdgeInsets.zero,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PlayVideoScreen(),)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Name', style: textStyle14(context),),
                              Text('Distributions', style: textStyle14(context, fontWeight: FontWeight.w400, color: CustomColor.descriptionColor),),
                            ],
                          ),
        
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(Icons.play_circle, size: 14,color: CustomColor.appColor,),
                                  5.width,
                                  Text('$video Video', style: textStyle12(context, color: CustomColor.appColor),),
        
                                ],
                              ),
                              Text('9$video % Completed', style: textStyle12(context, color: CustomColor.appColor),)
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
        ),
      ),
    );
  }
}
