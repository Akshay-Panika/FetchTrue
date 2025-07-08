import 'package:fetchtrue/feature/my_lead/widget/provider_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_icon.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_amount_text.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../helper/Contact_helper.dart';
import '../../provider/screen/provider__details_screen.dart';
import '../model/lead_model.dart';

class LeadDetailsWidget extends StatefulWidget {
  final LeadModel lead;
  final Dimensions dimensions;
  const LeadDetailsWidget({super.key, required this.dimensions, required this.lead});

  @override
  State<LeadDetailsWidget> createState() => _LeadDetailsWidgetState();
}

class _LeadDetailsWidgetState extends State<LeadDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return   Column(
      children: [
        SizedBox(height: widget.dimensions.screenHeight*0.01,),

        /// Booking card
        _buildBookingCard(context , lead: widget.lead),
        SizedBox(height: widget.dimensions.screenHeight*0.015,),

        /// Custom details card
        _customerDetails(context, widget.lead),
        SizedBox(height: widget.dimensions.screenHeight*0.015,),


        /// Payment status card
        _buildPaymentStatus(context, widget.lead),
        SizedBox(height: widget.dimensions.screenHeight*0.015,),

        /// Booking summary card
        _buildBookingSummary(context,widget.lead),
        SizedBox(height: widget.dimensions.screenHeight*0.02,),

        CustomContainer(
          width: double.infinity,
          backgroundColor: Colors.transparent,
          // backgroundColor: CustomColor.greenColor.withOpacity(0.1),
          margin: EdgeInsets.zero,
          child: RichText(
            textAlign: TextAlign.center,
              text: TextSpan(
            children: [
              TextSpan(text: 'You Will Earn', style: textStyle16(context, color: CustomColor.appColor)),
              WidgetSpan(child: 5.width),
              TextSpan(text: '${00}', style: textStyle16(context,color: CustomColor.greenColor)),
              WidgetSpan(child: 5.width),
              TextSpan(text: 'Commission From This Product', style: textStyle16(context, color: CustomColor.appColor)),
            ]
          )),),
        SizedBox(height: widget.dimensions.screenHeight*0.02,),


        /// Provider Card
        ProviderCardWidget(lead:widget.lead),
        SizedBox(height: widget.dimensions.screenHeight*0.015,),
      ],
    );
  }
}

/// Booking card
Widget _buildBookingCard(BuildContext context, { required LeadModel lead}){

  String bookingDate = 'Invalid date';
  try {
    bookingDate = DateFormat('dd-MM-yyyy, hh:mm a').format(DateTime.parse(lead.createdAt));
  } catch (e) {}

  String formattedServiceDate = 'N/A';
  try {
    if (lead.acceptedDate != null && lead.acceptedDate!.isNotEmpty) {
      formattedServiceDate = DateFormat('dd-MM-yyyy, hh:mm a').format(DateTime.parse(lead.acceptedDate!));
    }
  } catch (e) {}

  return CustomContainer(
    backgroundColor: Colors.white,
    margin: EdgeInsets.zero,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(lead.service.serviceName, style: textStyle14(context),),
            _buildStatusBadge(context,lead),
          ],
        ),
        Text('Lead Id: ${lead.bookingId}', style:  textStyle12(context,color: CustomColor.descriptionColor),),
        Divider(),
        _iconText(context,icon: Icons.calendar_month, text: 'Timing Details : $bookingDate'),
        _iconText(context,icon: Icons.calendar_month, text: 'Services Schedule Date: $formattedServiceDate'),
        10.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('OTP: 010101', style:  textStyle14(context,color: CustomColor.descriptionColor),),
            Text('Invoice Download', style:  textStyle14(context,color: CustomColor.appColor),),
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
      Icon(icon!, size: iconSize ?? 14,color: iconColor ?? Colors.grey,),
      Expanded(child: Text(text!, style: textStyle12(context, color: textColor ?? CustomColor.descriptionColor, fontWeight: fontWeight ??FontWeight.w400),))
    ],
  );
}

/// Status
Widget _buildStatusBadge(BuildContext context,LeadModel lead) {
  String statusText = 'Unknown';
  Color color = Colors.grey;

  // 🎯 Priority: isAccepted
  if (lead.isAccepted == true) {
    statusText = 'Accepted';
    color = Colors.green;
  } else {
    final status = lead.paymentStatus.toLowerCase();
    statusText = capitalize(status);

    if (status == 'pending') color = Colors.orange;
    if (status == 'ongoing') color = Colors.blue;
    if (status == 'cancel') color = Colors.red;
    if (status == 'completed') color = Colors.green;
  }

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
        const SizedBox(width: 5),
        Text(
          statusText,
          style: textStyle12(context, color: color),
        ),
      ],
    ),
  );
}

String capitalize(String value) {
  if (value.isEmpty) return value;
  return value[0].toUpperCase() + value.substring(1);
}


/// Customer details
Widget _customerDetails(BuildContext context, LeadModel lead){
  final phoneNumber = lead.serviceCustomer;
  final message = 'Hello, I am contacting you from Fetch True.';

  return CustomContainer(
    border: false,
    backgroundColor: Colors.white,
    margin: EdgeInsets.zero,
    child: Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _iconText(context,
              icon: Icons.person,
              iconSize: 16,
              iconColor: CustomColor.appColor,
              text: 'Customer Details',
              fontWeight: FontWeight.w500,
              textColor: Colors.black,),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name : ${lead.serviceCustomer.fullName}', style: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),
                Text('Phone : ${lead.serviceCustomer.phone}',  style: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),
                // Text('Email Id : ${lead.serviceCustomer!.email}',  style: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),
                Text('Address: ${lead.serviceCustomer.city}',  style: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),

                if(lead.notes.isNotEmpty)
                CustomContainer(
                    margin: EdgeInsets.only(top: 10),
                    child: Text('Note: ${lead.notes}',  style: textStyle14(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),)),

              ],
            ),
       ],
        ),

        Positioned(
            top: 20,right: 20,
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(onTap: () => ContactHelper.whatsapp(phoneNumber.toString(), message),
                    child: Image.asset(CustomIcon.whatsappIcon, height: 25, )),
                40.width,
                InkWell(onTap: () => ContactHelper.call(phoneNumber.toString()),
                    child: Image.asset(CustomIcon.phoneIcon, height: 25, color: CustomColor.appColor,)),

              ],
            ))
      ],
    ),
  );
}

/// Payment status
Widget _buildPaymentStatus(BuildContext context, LeadModel lead){
  return CustomContainer(
    border: false,
    backgroundColor: Colors.white,
    margin: EdgeInsets.zero,
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _iconText( context,
                icon: Icons.currency_rupee,
                iconSize: 16,
                iconColor: CustomColor.appColor,
                text: 'Payment Status',
                fontWeight: FontWeight.w500,
                textColor: Colors.black,),
              10.height,

              Text('Status: ${lead.paymentMethod}', style: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),
              Text('Transaction Id:',  style: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),
            ],
          ),
        ),

        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          spacing: 20,
          children: [
            Text('${lead.paymentStatus}', style: TextStyle(color: CustomColor.appColor, fontWeight: FontWeight.w500),),
            CustomAmountText(amount: '${lead.serviceDiscount}', color: CustomColor.appColor,fontWeight: FontWeight.w500,fontSize: 14)
          ],
        ),

      ],
    ),
  );
}

Widget _buildBookingSummary(BuildContext context, LeadModel lead){
  return CustomContainer(
    border: false,
    backgroundColor: Colors.white,
    margin: EdgeInsets.zero,
    child: Column(
      spacing: 10,
      children: [
        _buildRow(context,label: 'Sub Total', value: '${lead.serviceDiscount}' ),
        _buildRow(context,label: 'Coupon Discount', value: '${lead.couponDiscount}' ),
        _buildRow(context ,label: 'Campaign Discount', value: '${lead.champaignDiscount}'),
        _buildRow(context ,label: 'Platform Fee', value: '${lead.platformFee}'),
        _buildRow(context ,label: 'Guarantee Fee', value: '${lead.platformFee}'),
        Divider(),
        _buildRow(context,label: 'Grand Total', value: '${lead.serviceDiscount}' , textColor: CustomColor.appColor),
      ],
    ),
  );
}

Widget _buildRow(BuildContext context,{String? label, Color? textColor, String? value}){
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label!, style: textStyle12(context,color: textColor ?? CustomColor.descriptionColor),),
      CustomAmountText(amount: value!, color: textColor ?? CustomColor.descriptionColor, fontSize: 12),
    ],
  );
}


