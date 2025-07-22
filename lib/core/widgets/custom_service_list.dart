import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../feature/service/screen/service_details_screen.dart';
import '../costants/custom_color.dart';
import '../costants/text_style.dart';
import 'custom_amount_text.dart';
import 'custom_container.dart';
import 'custom_favorite_button.dart';
import 'custom_headline.dart';

class CustomServiceList extends StatelessWidget {
  final String headline;
   CustomServiceList({super.key, required this.headline});

  final List<Map<String, String>> bannerData = [
    {
      'image' : 'assets/image/thumbnail2.png'
    },
    {
      'image' : 'assets/image/thumbnail1.png'
    },
    {
      'image' : 'assets/image/thumbnail2.png'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomHeadline(headline: headline,),
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: bannerData.length,
            itemBuilder: (context, index) {
              return CustomContainer(
                border: false,
                width: 300,
                backgroundColor: Colors.white,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceDetailsScreen(serviceId: '',),)),
                padding: EdgeInsets.all(0),
                margin: EdgeInsets.only(right: 0, left: 10,bottom: 10,top: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: CustomContainer(
                        margin: EdgeInsets.all(0),
                        padding: EdgeInsets.all(0),
                        assetsImg: '${bannerData[index]['image']}',
                        child: Align(
                            alignment: Alignment.topRight,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomFavoriteButton(),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                      color: CustomColor.blackColor.withOpacity(0.3),
                                    ),
                                )
                              ],
                            ),
                        ),
                      ),
                    ),

                    10.height,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Service Name : Akshay Panika', style: textStyle12(context),),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Row(
                               children: [
                                 Text('Start from ', style: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),
                                 CustomAmountText(amount: '00.0', color: CustomColor.descriptionColor,),
                               ],
                             ),
                             Row(
                               children: [
                                 Text('Earn up to ', style: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),
                                 CustomAmountText(amount: '00.0', color: CustomColor.descriptionColor),
                               ],
                             ),
                           ],
                         ),
                          // 5.height,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text('Keys :', style: textStyle12(context,color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),
                                  5.width,
                                  Text('value',style: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('Keys :', style: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),
                                  5.width,
                                  Text('value',style: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),
                                ],
                              ),
                            ],
                          ),
                          10.height,
                        ],
                      ),
                    ),

                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
