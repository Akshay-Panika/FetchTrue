import 'package:bizbooster2x/core/widgets/custom_amount_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../features/service/screen/service_details_screen.dart';
import 'custom_container.dart';
import 'custom_headline.dart';

class CustomServiceList extends StatelessWidget {
  const CustomServiceList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomHeadline(headline: 'Most Popular Services',),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return CustomContainer(
                width: 300,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceDetailsScreen(),)),
                padding: EdgeInsets.all(0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: CustomContainer(
                        margin: EdgeInsets.all(0),
                        padding: EdgeInsets.all(0),
                        child: Align(
                            alignment: Alignment.topRight,
                            child: IconButton(onPressed: () {}, icon: Icon(Icons.favorite_border))),
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
