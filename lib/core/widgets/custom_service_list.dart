import 'package:bizbooster2x/core/widgets/custom_amount_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../features/service/screen/service_details_screen.dart';
import 'custom_container.dart';
import 'custom_favorite_button.dart';
import 'custom_headline.dart';

class CustomServiceList extends StatelessWidget {
  final String headline;
   CustomServiceList({super.key, required this.headline});

  final List<Map<String, String>> bannerData = [
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
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: bannerData.length,
            itemBuilder: (context, index) {
              return CustomContainer(
                width: 300,
                backgroundColor: Colors.white,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceDetailsScreen(image: '${bannerData[index]['image']}',),)),
                padding: EdgeInsets.all(0),
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
                            child: CustomFavoriteButton(),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Service Name', style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Row(
                               children: [
                                 Text('Start from: ', style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                                 CustomAmountText(amount: '100'),
                               ],
                             ),
                             Row(
                               children: [
                                 Text('Earn up to ', style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                                 CustomAmountText(amount: '50'),
                               ],
                             ),
                           ],
                         )
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
