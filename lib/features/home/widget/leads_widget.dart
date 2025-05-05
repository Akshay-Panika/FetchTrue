import 'package:bizbooster2x/features/my_lead/screen/my_Lead_screen.dart';
import 'package:bizbooster2x/features/team_lead/screen/team_lead_screen.dart';
import 'package:bizbooster2x/features/wallet/screen/wallet_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/costants/custom_color.dart';
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
          height: 100,
          child: Row(
            children: [
              Expanded(
                child: CustomContainer(
                  height: double.infinity,
                  margin: EdgeInsets.only(left: 10),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => WalletScreen(),)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.currency_rupee,color: CustomColor.appColor, size: 50,),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(text:'Total Earning : ', style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500, color: Colors.black),),
                              WidgetSpan(child: Icon(Icons.currency_rupee, size: 14,)),
                              TextSpan(text:'5000.00', style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500, color: Colors.black),),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),),
              SizedBox(width: 10,),

              Expanded(
                child: Column(
                  children: [
                   Expanded(child:  CustomContainer(
                     width: double.infinity,
                     margin: EdgeInsets.only(right: 10),
                     // padding: EdgeInsets.all(0),
                     onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MyLeadScreen(isHome: 'isHome',),)),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceAround,
                       children: [
                        Icon(Icons.bookmark_outline, color: CustomColor.appColor,),

                         RichText(
                           text: TextSpan(
                             children: [
                               TextSpan(text:'My Leads : ', style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500, color: Colors.black),),
                               TextSpan(text:'50', style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500, color: Colors.black),),
                             ],
                           ),
                         ),

                       ],
                     ),
                   ),),
                   SizedBox(height:10,),
                   Expanded(child:  CustomContainer(
                     width: double.infinity,
                     margin: EdgeInsets.only(right: 10),
                    // padding: EdgeInsets.all(0),
                     onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TeamLeadScreen(),)),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceAround,
                       children: [
                         RichText(
                           text: TextSpan(
                             children: [
                               TextSpan(text:'Team Lead : ', style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500, color: Colors.black),),
                               TextSpan(text:'50', style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500, color: Colors.black),),
                             ],
                           ),
                         ),
                        Icon(Icons.leaderboard_outlined, color: CustomColor.appColor),
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
