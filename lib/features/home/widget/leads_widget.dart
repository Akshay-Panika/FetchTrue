import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/custom_container.dart';

class LeadsWidget extends StatelessWidget {
  const LeadsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Text('Leads', style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),
        ),
        SizedBox(
          height: 200,
          child: Row(
            children: [
              Expanded(
                child: CustomContainer(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: CustomContainer(
                          margin: EdgeInsets.only(bottom: 20,right: 20),
                        ),
                      ),
                      Text('Total Earning : 456', style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                    ],
                  ),
                ),),
              Expanded(
                child: Column(
                  children: [
                   Expanded(child:  CustomContainer(
                     width: double.infinity,
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.start,
                       crossAxisAlignment: CrossAxisAlignment.end,
                       children: [
                         Expanded(
                           child: CustomContainer(
                             margin: EdgeInsets.only(bottom: 0,right: 10),
                           ),
                         ),
                         Text('My Leads : 105', style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                       ],
                     ),
                   ),),
                   Expanded(child:  CustomContainer(
                     width: double.infinity,
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.start,
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text('Team Leads : 456', style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                         Expanded(
                           child: CustomContainer(
                             margin: EdgeInsets.only(bottom: 0,left: 10),
                           ),
                         ),
                       ],
                     ),
                   ),),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
