import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_url_launch.dart';

class LeadStatusWidget extends StatelessWidget {
  const LeadStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _header(context,header: 'Lead Requested', desc: 'You have submitted a request for a lead.\nAwaiting admin approval.'),
        _header(context,header: 'Initial Contact', desc: 'The admin has initiated the first communication.',),
        _header(context,header: 'Need Understand Rearmament', desc: 'The admin has initiated the first communication.', isMeet: true),
        _header(context,header: 'Payment Requested (Partial/Full)', desc: 'Proceed with payment to continue.', isPayment: true),
        _header(context,header: 'Payment Verified', desc: 'The admin has verified your payment'),
        _header(context,header: 'Lead Accepted', desc: 'The admin has approved your lead request'),
        _header(context,header: 'Lead Requested Documents', desc: 'The admin has approved your lead request'),
        _header(context,header: 'Lead Started', desc: 'Your lead has officially begun'),
        _header(context,header: 'Lead Ongoing', desc: 'Description....'),
        _header(context,header: 'Lead Completed', desc: 'Description....'),
        _header(context,header: 'Lead Cancel', desc: 'Description....'),
        _header(context,header: 'Refund', desc: 'Description....', endData: true),

      ],
    );
  }
}


Widget _header(BuildContext context, {String? header, String? desc, bool isMeet = false, bool isPayment = false, String? meetMSG, bool endData = false}){
  return IntrinsicHeight(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade300,
              ),
              child: Icon(Icons.check_circle, color: Colors.green.shade300,),),

            if(!endData)
            Expanded(
              child: CustomContainer(
                width: 2,
                backgroundColor:  Colors.grey.shade300,margin: EdgeInsets.zero, padding: EdgeInsets.zero,),
            )
          ],
        ),

        10.width,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('$header,', style: textStyle14(context),),
                  10.width,
                  Text('(Time, Date)', style: textStyle12(context, fontWeight: FontWeight.w400),),
                ],
              ),
              Text(desc!, style: textStyle14(context,fontWeight: FontWeight.w400),),

              if (isMeet)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    10.height,
                     Row(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       mainAxisAlignment: MainAxisAlignment.start,
                       children: [
                         CircleAvatar(backgroundColor: CustomColor.whiteColor,child: Icon(Icons.g_mobiledata_outlined, color: CustomColor.appColor,)),
                         10.width,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Google Meed (Time, 12:30 PM, At, 02/08/25)', style: textStyle14(context, fontWeight: FontWeight.w400),),
                              Text('https://meet.google.com', style: textStyle14(context, fontWeight: FontWeight.w400, color: CustomColor.appColor),),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                      onTap: () {
                                        CustomUrlLaunch('https://meet.google.com/landing');
                                      },
                                      child: Text('Join Now', style: textStyle14(context, color: CustomColor.greenColor),)),
                                ],
                              )
                            ],
                          ),
                        ),
                       ],
                     ),
                    10.height,
    
                    Text(meetMSG ?? 'The scheduled meeting has been successfully conducted')
                  ],
                ),

              if (isPayment)
                Column(
                  children: [
                    10.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(backgroundColor: CustomColor.whiteColor,child: Icon(Icons.g_mobiledata_outlined, color: CustomColor.appColor,)),
                        10.width,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Payment Request', style: textStyle14(context, fontWeight: FontWeight.w400),),
                              InkWell(
                                  onTap: () {
                                    CustomUrlLaunch('https://zeropls.com');
                                  },
                                  child: Text('paymentlink.com', style: textStyle14(context, fontWeight: FontWeight.w400, color: CustomColor.appColor),)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  InkWell(
                                      onTap: () {
                                        CustomUrlLaunch('https://checkout.rocketpay.co.in/md/684e8cc5d9c45b89310b8e01');
                                      },
                                      child: Text('Pay Now', style: textStyle14(context, color: CustomColor.greenColor),)),
                                  30.width,
                                  InkWell(
                                      onTap: () {
                                        CustomUrlLaunch('https://checkout.rocketpay.co.in/md/684e8cc5d9c45b89310b8e01');
                                      },
                                      child: Text('Share To Pay', style: textStyle14(context, color: CustomColor.appColor),)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    10.height,
    
                    Text(meetMSG ?? 'You have successfully made a payment Awaiting verification from the admin')
                  ],
                ),
              20.height
            ],
          ),
        )
    
      ],
    ),
  );
}