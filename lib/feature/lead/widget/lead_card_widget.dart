

import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/formate_price.dart';
import '../model/lead_model.dart';
import 'leads_details_widget.dart';

Widget buildBookingCard(BuildContext context, { required BookingData lead}){

  return CustomContainer(
    border: true,
    color: Colors.white,
    margin: EdgeInsets.zero,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(lead.service!.serviceName.toString(), style: textStyle14(context),),
            Text(
              '[ ${getLeadStatus(lead)} ]',
              style: textStyle12(context, fontWeight: FontWeight.bold, color: getStatusColor(lead)),
            )
          ],
        ),
        Text('Lead Id: ${lead.bookingId}', style:  textStyle12(context,color: CustomColor.descriptionColor),),
        Divider(),
        _iconText(context,icon: Icons.calendar_month, text: 'Booking Date : ${formatDateTime(lead.createdAt)}'),
        _iconText(context,icon: Icons.calendar_month, text: 'Schedule Date: ${formatDateTime(lead.acceptedDate)}'),
        10.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('OTP: ${lead.otp}', style:  textStyle14(context,color: CustomColor.descriptionColor),),
            InkWell(
              onTap: () async {
                final url = Uri.parse('https://biz-booster.vercel.app/api/invoice/${lead.id}');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                } else {
                  throw 'Could not launch $url';
                }
              },
              child: Text(
                'Invoice Download',
                style: textStyle14(context, color: CustomColor.appColor),
              ),
            )
          ],
        ),

      ],
    ),
  );
}


Widget _iconText(BuildContext context,{IconData? icon, double? iconSize,Color? iconColor, String? text, Color? textColor,FontWeight? fontWeight}){
  return Row(
    spacing: 10,
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Icon(icon!, size: iconSize ?? 14,color: iconColor ?? CustomColor.appColor,),
      Expanded(child: Text(text!, style: textStyle12(context, color: textColor ?? CustomColor.blackColor, fontWeight: fontWeight ??FontWeight.w400),))
    ],
  );
}
