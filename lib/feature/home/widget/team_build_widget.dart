import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_headline.dart';
import '../../auth/firebase_uth/PhoneNumberScreen.dart';
import '../../extra_earning/screen/extra_earning_screen.dart';
import '../../my_lead/screen/my_Lead_screen.dart';
import '../../rating_review/screen/ratting_review_screen.dart';
import '../../team_build/screen/team_build_screen.dart';
import '../../wallet/screen/wallet_screen.dart';

class LeadsWidget extends StatelessWidget {
  const LeadsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return SizedBox(
      height: dimensions.screenHeight*0.15,
      child: Row(
        children: [
          Expanded(
            child: CustomContainer(
              assetsImg: 'assets/image/totalEarningBackImg.jpg',
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
                  assetsImg: 'assets/image/myLeadBackImg.jpg',
                  width: double.infinity,
                  margin: EdgeInsets.only(right: 10),
                  border: true,
                  backgroundColor: CustomColor.whiteColor,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PhoneNumberScreen(),)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.asset('assets/lead/my_lead_icon.jpg',),

                      Text('Extra Earning\nTask 50',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500, color: Colors.black),)

                      // RichText(
                      //   text: TextSpan(
                      //     children: [
                      //       TextSpan(text:'Extra Earning ', style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500, color: Colors.black),),
                      //       TextSpan(text:' Lead 50', style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500, color: Colors.black),),
                      //     ],
                      //   ),
                      // ),

                    ],
                  ),
                ),),
                SizedBox(height:10,),
                Expanded(child:  CustomContainer(
                  assetsImg: 'assets/image/teamLeadBackImg.jpg',
                  width: double.infinity,
                  margin: EdgeInsets.only(right: 10),
                  border: true,
                  backgroundColor: CustomColor.whiteColor,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TeamLeadScreen(),)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(text:'Team Build : ', style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500, color: Colors.black),),
                            TextSpan(text:'50', style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500, color: Colors.black),),
                          ],
                        ),
                      ),
                      Image.asset('assets/lead/team_lead_icon.png',),
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
