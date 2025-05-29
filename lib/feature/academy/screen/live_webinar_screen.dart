import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/core/costants/custom_image.dart';
import 'package:bizbooster2x/core/costants/text_style.dart';
import 'package:bizbooster2x/core/widgets/custom_headline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/costants/dimension.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';
import 'enroll_now_screen.dart';

class LiveWebinarScreen extends StatelessWidget {
  const LiveWebinarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return Scaffold(
      appBar: CustomAppBar(title: 'Live Webinar', showBackButton: true,),

      body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                  itemCount: 2,
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: dimensions.screenWidth*0.03),
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                   return CustomContainer(
                     border: true,
                      backgroundColor: CustomColor.whiteColor,
                      padding: EdgeInsets.zero,
                     height: dimensions.screenHeight*0.25,
                     margin: EdgeInsets.only(top: dimensions.screenHeight*0.015),
                      child: Column(
                        children: [
                          Expanded(
                            child: CustomContainer(
                             margin: EdgeInsets.zero,
                             assetsImg: CustomImage.thumbnailImage,
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Name', style: textStyle14(context),),
                                    Text('Distribution', style: textStyle12(context,color: CustomColor.descriptionColor),),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Date:', style: textStyle12(context),),
                                        SizedBox(width: dimensions.screenWidth*0.03,),
                                        Text('Time:', style: textStyle12(context),),
                                      ],
                                    ),
                                    CustomContainer(
                                      backgroundColor: CustomColor.appColor,
                                      margin: EdgeInsets.zero,
                                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                                      child: Text('Enroll Now', style: textStyle12(context, color: CustomColor.whiteColor),),)
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                     onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EnrollNowScreen(),)),
                    );
                  },
                ),

                SizedBox(height: dimensions.screenHeight*0.02,),
                CustomHeadline(headline: 'Attend at least 3 live webinar to move forward', viewSeeAll: false,),
                ListView.builder(
                  itemCount: 2,
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: dimensions.screenWidth*0.03),
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                   return Stack(
                     children: [
                       CustomContainer(
                         border: true,
                          backgroundColor: CustomColor.whiteColor,
                          padding: EdgeInsets.zero,
                         height: dimensions.screenHeight*0.1,
                         margin: EdgeInsets.only(top: dimensions.screenHeight*0.015),
                          child: Row(
                            children: [
                              CustomContainer(
                                width: dimensions.screenWidth*0.35,
                               margin: EdgeInsets.zero,
                               assetsImg: CustomImage.thumbnailImage,
                              ),
                       
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Name', style: textStyle14(context),),
                                      Text('Distribution', style: textStyle12(context,color: CustomColor.descriptionColor),),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                       
                       Positioned(
                           top: 20,right: 20,
                           child: Icon(Icons.library_add_check_outlined, color: CustomColor.appColor,))
                     ],
                   );
                  },
                ),
              ],
            ),
          )
      ),
    );
  }
}
