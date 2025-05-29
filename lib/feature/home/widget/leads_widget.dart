import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/costants/custom_color.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_headline.dart';
import '../../my_lead/screen/my_Lead_screen.dart';
import '../../team_lead/screen/team_lead_screen.dart';
import '../../wallet/screen/wallet_screen.dart';

class LeadsWidget extends StatelessWidget {
  const LeadsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return SizedBox(
      height: dimensions.screenHeight*0.13,
      child: Row(
        children: [
          Expanded(
            child: CustomContainer(
              height: double.infinity,
              margin: EdgeInsets.only(left: 10),
              border: true,
              backgroundColor: CustomColor.whiteColor,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => WalletScreen(),)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: Image.asset('assets/lead/total_earning_icon.png',)),
                  10.height,
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
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  border: true,
                  backgroundColor: CustomColor.whiteColor,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MyLeadScreen(isBack: 'isBack',),)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.asset('assets/lead/my_lead_icon.jpg',),

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
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  border: true,
                  backgroundColor: CustomColor.whiteColor,
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
                      Image.asset('assets/lead/team_lead_icon.jpg',),
                    ],
                  ),
                ),),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
