import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/custom_container.dart';

class RecommendedServicesWidget extends StatelessWidget {
  const RecommendedServicesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Text(
            'Recommended Services',
            style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),
          ),
        ),
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
