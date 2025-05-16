import 'dart:ffi';

import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/core/widgets/custom_amount_text.dart';
import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';
import 'package:bizbooster2x/core/widgets/custom_toggle_taps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LeadDetailsScreen extends StatefulWidget {
  const LeadDetailsScreen({super.key});

  @override
  State<LeadDetailsScreen> createState() => _LeadDetailsScreenState();
}

class _LeadDetailsScreenState extends State<LeadDetailsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Lead Details', showBackButton: true,),

      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            _buildBookingCard(),
            SizedBox(height: 10,),

            _customerDetails(),
            SizedBox(height: 10,),

            _buildPaymentStatus(),
            SizedBox(height: 10,),

            _buildBookingSummary()
          ],
        ),
      )),
    );
  }
}


/// Booking card
Widget _buildBookingCard(){
  return CustomContainer(
    border: true,
    backgroundColor: Colors.white,
    margin: EdgeInsets.zero,
    child: Column(
      spacing: 5,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Booking #100307', style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),
            _buildStatusBadge('Pending'),
          ],
        ),
        _iconText(icon: Icons.calendar_month, text: 'Timing Details : 6 May 2025 08:50 PM'),
        _iconText(icon: Icons.calendar_month, text: 'Services Schedule Date : 6 May 2025 08:50 PM'),
        _iconText(icon: Icons.location_on_outlined, text: 'Address : Office ve jkw 3br#429, Amanora Chambers Pune'),
      ],
    ),
  );
}

Widget _iconText({IconData? icon, double? iconSize,Color? iconColor, String? text, Color? textColor,double? fontSize}){
  return Row(
    spacing: 10,
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Icon(icon!, size: iconSize ?? 14,color: iconColor ?? Colors.grey,),
      Expanded(child: Text(text!, style: TextStyle(fontSize: fontSize ?? 14, color: textColor ??Colors.grey.shade700),))
    ],
  );
}

/// Status
Widget _buildStatusBadge(String status) {
  Color color = Colors.grey;
  if (status == 'Completed') color = Colors.green;
  if (status == 'Pending') color = Colors.orange;
  if (status == 'Accepted') color = Colors.purple;
  if (status == 'Ongoing') color = Colors.blue;

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      border: Border.all(color: color, width: 0.5),
      borderRadius: BorderRadius.circular(5),
      color: color.withOpacity(0.1),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.circle, size: 10, color: color),
        const SizedBox(width: 6),
        Text(
          status, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500),),
      ],
    ),
  );
}


Widget _customerDetails(){
  return CustomContainer(
    border: true,
    backgroundColor: Colors.white,
    margin: EdgeInsets.zero,
    child: Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _iconText(
                icon: Icons.person,
                iconSize: 16,iconColor: CustomColor.appColor,
                text: 'Customer Details',
                textColor: Colors.black,),
            
               Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text('Name :', style: TextStyle(color: Colors.grey.shade700),),
                   Text('Phone :', style: TextStyle(color: Colors.grey.shade700),),
                 ],
               ),
            
            Text('Address: Waidhan Singrauli MP', style: TextStyle(color: Colors.grey.shade700),)
          ],
        ),
        
        Positioned(
            top: 0,right: 0,
            child:  Row(
          children: [
            IconButton(onPressed: (){}, icon: Icon(CupertinoIcons.phone_fill, size: 22, color: CustomColor.appColor,)),
            IconButton(onPressed: (){}, icon: Icon(CupertinoIcons.phone_circle_fill, size: 22, color: CustomColor.appColor,)),
          ],
        ))
      ],
    ),
  );
}

Widget _buildPaymentStatus(){
  return CustomContainer(
    border: true,
    backgroundColor: Colors.white,
    margin: EdgeInsets.zero,
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _iconText(
                  icon: Icons.currency_rupee, iconColor: CustomColor.appColor,
                  text: 'Payment Status',textColor: Colors.black
              ),
          
              SizedBox(height: 10,),
              Text('Cash after service', style: TextStyle(color: Colors.grey.shade700),),
              Text('Transaction Id :', style: TextStyle(color: Colors.grey.shade700),),
            ],
          ),
        ),
        
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          spacing: 20,
          children: [
            Text('Unpaid', style: TextStyle(color: CustomColor.appColor, fontWeight: FontWeight.w500),),
            CustomAmountText(amount: '5,999.00', color: CustomColor.appColor,fontWeight: FontWeight.w500,fontSize: 14)
          ],
        ),

      ],
    ),
  );
}

Widget _buildBookingSummary(){
  return CustomContainer(
    border: true,
    backgroundColor: Colors.white,
    margin: EdgeInsets.zero,
    child: Column(
      spacing: 10,
      children: [
        _buildRow(label: 'Sub Total', value: '5,999.00' ),
        _buildRow(label: 'Service Discount', value: '00' ),
        _buildRow(label: 'Coupon Discount', value: '00' ),
        _buildRow(label: 'Campaign Discount', value: '00' ),
        Divider(),
        _buildRow(label: 'Grand Total', value: '00' , textColor: CustomColor.appColor),
      ],
    ),
  );
}

Widget _buildRow({String? label, Color? textColor, String? value}){
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label!, style: TextStyle(color: textColor ?? Colors.grey.shade700),),
      CustomAmountText(amount: value!, color: textColor ?? Colors.grey.shade700, fontSize: 14),
    ],
  );
}



