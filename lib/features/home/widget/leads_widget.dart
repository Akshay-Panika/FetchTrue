import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_headline.dart';

class LeadsWidget extends StatelessWidget {
  const LeadsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomHeadline(headline: 'Leads',),

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
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(text:'Total Earning : ', style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500, color: Colors.black),),
                            TextSpan(text:'5000', style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500, color: Colors.black),),
                          ],
                        ),
                      ),
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
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Expanded(
                           child: CustomContainer(
                            margin: EdgeInsets.all(0),
                           ),
                         ),
                         SizedBox(width: 10,),
                         Expanded(
                           child: RichText(
                             text: TextSpan(
                               children: [
                                 TextSpan(text:'My Leads : ', style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500, color: Colors.black),),
                                 TextSpan(text:'50', style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500, color: Colors.black),),
                               ],
                             ),
                           ),
                         ),

                       ],
                     ),
                   ),),
                   Expanded(child:  CustomContainer(
                     width: double.infinity,
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.start,
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Expanded(
                           child: RichText(
                             text: TextSpan(
                               children: [
                                 TextSpan(text:'Team Leads : ', style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500, color: Colors.black),),
                                 TextSpan(text:'15', style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500, color: Colors.black),),
                               ],
                             ),
                           ),
                         ),
                         SizedBox(width: 10,),
                         Expanded(
                           child: CustomContainer(
                             margin: EdgeInsets.all(0),
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
