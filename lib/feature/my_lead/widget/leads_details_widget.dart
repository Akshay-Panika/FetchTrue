import 'package:fetchtrue/feature/my_lead/widget/provider_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_icon.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_amount_text.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../helper/Contact_helper.dart';
import '../model/leads_model.dart';

class LeadsDetailsWidget extends StatefulWidget {
  final LeadsModel lead;
  const LeadsDetailsWidget({super.key, required this.lead});

  @override
  State<LeadsDetailsWidget> createState() => _LeadsDetailsWidgetState();
}

class _LeadsDetailsWidgetState extends State<LeadsDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return   SingleChildScrollView(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
      child: Column(
        children: [
          SizedBox(height: dimensions.screenHeight*0.01,),
      
          /// Booking card
          _buildBookingCard(context , lead: widget.lead),
          SizedBox(height: dimensions.screenHeight*0.015,),
      
          /// Custom details card
          _customerDetails(context, widget.lead),
          SizedBox(height: dimensions.screenHeight*0.015,),
      
      
          /// Payment status card
          _buildPaymentStatus(context, widget.lead),
          SizedBox(height: dimensions.screenHeight*0.015,),
      
          /// Booking summary card
          _buildBookingSummary(context,widget.lead),

          CustomContainer(
            border: true,
            width: double.infinity,
            backgroundColor: CustomColor.whiteColor,
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      20.height,
                     Text('You Will Earn Commission', style: textStyle16(context, color: CustomColor.appColor),)  ,
                     Row(
                       children: [
                         Text('Up To', style: textStyle14(context),),
                         10.width,
                         Text('00', style: textStyle16(context, color: Colors.green),),
                       ],
                     )  ,
                    ],
                  ),
                ),
                Image.asset('assets/package/packageBuyImg.png', height: 100,)
              ],
            ),),
      
          /// Provider Card
          ProviderCardWidget(lead:widget.lead),
          50.height
        ],
      ),
    );
  }
}

/// Booking card
Widget _buildBookingCard(BuildContext context, { required LeadsModel lead}){

  /// Format Date
  String formatDate(String? rawDate) {
    if (rawDate == null) return 'N/A';
    final date = DateTime.tryParse(rawDate);
    if (date == null) return 'Invalid Date';
    return DateFormat('dd MMM yyyy').format(date);
  }

  return CustomContainer(
    border: true,
    backgroundColor: Colors.white,
    margin: EdgeInsets.zero,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(lead.service.serviceName, style: textStyle14(context),),
            Text(
              '[ ${getLeadStatus(lead)} ]',
              style: textStyle12(context, fontWeight: FontWeight.bold, color: getStatusColor(lead)),
            )
          ],
        ),
        Text('Lead Id: ${lead.bookingId}', style:  textStyle12(context,color: CustomColor.descriptionColor),),
        Divider(),
        _iconText(context,icon: Icons.calendar_month, text: 'Booking Date : ${formatDate(lead.createdAt)}'),
        _iconText(context,icon: Icons.calendar_month, text: 'Schedule Date: ${formatDate(lead.acceptedDate)}'),
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

/// Lead Status
String getLeadStatus(lead) {
  if (lead.isCanceled == true) return 'Cancel';
  if (lead.isCompleted == true) return 'Completed';
  if (lead.isAccepted == true) return 'Accepted';
  return 'Pending';
}

/// Status Color
Color getStatusColor(lead) {
  if (lead.isCanceled == true) return Colors.red;
  if (lead.isCompleted == true) return Colors.green;
  if (lead.isAccepted == true) return Colors.orange;
  return Colors.grey;
}

String capitalize(String value) {
  if (value.isEmpty) return value;
  return value[0].toUpperCase() + value.substring(1);
}


/// Customer details
Widget _customerDetails(BuildContext context, LeadsModel lead){
  final phoneNumber = lead.serviceCustomer.phone;
  final message = 'Hello, I am contacting you from Fetch True.';

  return CustomContainer(
    border: true,
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
Widget _buildPaymentStatus(BuildContext context, LeadsModel lead){
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

Widget _buildBookingSummary(BuildContext context, LeadsModel lead){
  return CustomContainer(
    border: true,
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


