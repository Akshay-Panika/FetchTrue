import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';

class EnrollNowScreen extends StatefulWidget {
  const EnrollNowScreen({super.key});

  @override
  State<EnrollNowScreen> createState() => _EnrollNowScreenState();
}

class _EnrollNowScreenState extends State<EnrollNowScreen> {

  bool _itEnroll = false;

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);

    return Scaffold(
      appBar: CustomAppBar(title: 'Webinar', showBackButton: true,),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: dimensions.screenWidth*0.03),
          child: Column(
          children: [
            CustomContainer(
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
            ),

            20.height,
            CustomContainer(
              border: true,
              width: double.infinity,
              margin: EdgeInsets.zero,
              backgroundColor: CustomColor.whiteColor,
              onTap: () {
                setState(() {
                  _itEnroll = !_itEnroll;
                });
              },
              child: Column(
                children: [


                  _itEnroll ?
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      20.height,
                      Text('Test webinar description', style: textStyle14(context, color: CustomColor.descriptionColor),),
                      10.height,
                      Text('Enroll Now', style: textStyle20(context, color: CustomColor.appColor),),
                      20.height,
                    ],
                  ):
                  Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.videocam_outlined, color: CustomColor.appColor,),
                          5.width,
                          Text('https://meet.google.com', style: textStyle14(context, color: CustomColor.appColor, fontWeight: FontWeight.w400),)
                        ],
                      ),
                      20.height,

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _card(context,
                            label: 'Copy',
                            icon: Icons.copy,
                            onTap: () => null,
                          ),

                          _card(context,
                            label: 'Join',
                            icon: Icons.phonelink_rounded,
                            onTap: () => null,
                          ),
                        ],
                      ),
                      20.height,

                      Text('Time Remaining', style: textStyle14(context, color: CustomColor.descriptionColor),),
                      10.height,

                     Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: [
                         RichText(
                             text: TextSpan(
                                 children: [
                                   TextSpan(text: '00.0',style: textStyle20(context)),
                                   TextSpan(text: 'hr', style: textStyle16(context)),
                                 ]
                             )
                         ),
                         50.width,
                         RichText(
                             text: TextSpan(
                                 children: [
                                   TextSpan(text: '00.0',style: textStyle20(context)),
                                   TextSpan(text: 'min', style: textStyle16(context)),
                                 ]
                             )
                         )
                       ],
                     )
                    ],
                  )
                ],
              ),
            )
          ],
          ),
        )),
    );
  }
}


Widget _card(BuildContext context, {VoidCallback ? onTap,required String label, required IconData icon}){
  return CustomContainer(
    border: true,
    backgroundColor: CustomColor.whiteColor,
    margin: EdgeInsets.zero,
    onTap: onTap,
    padding: EdgeInsets.symmetric(horizontal: 30,vertical: 5),
    child: Row(
      children: [
        Text(label, style: textStyle14(context, color: CustomColor.appColor),),
        10.width,
        Icon(icon, size: 16,color: CustomColor.appColor,)
      ],
    ),
  );
}