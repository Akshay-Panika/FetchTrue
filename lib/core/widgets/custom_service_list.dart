import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
                padding: EdgeInsets.all(0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: CustomContainer(
                        margin: EdgeInsets.all(0),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(5.0),
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
                                 Text('10.00', style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                                 Icon(Icons.currency_rupee, size: 12,)
                               ],
                             ),
                             Row(
                               children: [
                                 Text('Start from: ', style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                                 Text('10.00', style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                                 Icon(Icons.currency_rupee, size: 12,)
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
