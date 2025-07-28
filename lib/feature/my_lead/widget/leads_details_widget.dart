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

          _buildCommissionCard(context),
          SizedBox(height: dimensions.screenHeight*0.015,),

          /// Custom details card
          _customerDetails(context, widget.lead),
          SizedBox(height: dimensions.screenHeight*0.015,),
      
      
          /// Payment status card
          _buildPaymentStatus(context, widget.lead),
          SizedBox(height: dimensions.screenHeight*0.015,),
      
          /// Booking summary card
          _buildBookingSummary(context,widget.lead),
          SizedBox(height: dimensions.screenHeight*0.015,),
      
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
            Text('OTP: ${lead.otp}', style:  textStyle14(context,color: CustomColor.descriptionColor),),
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
    width: double.infinity,
    child: Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Customer Details', style: textStyle12(context),),
            5.height,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name : ${lead.serviceCustomer.fullName}', style: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),
                Text('Phone : ${lead.serviceCustomer.phone}',  style: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),
                // Text('Email Id : ${lead.serviceCustomer!.email}',  style: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),
                Text('Address: ${lead.serviceCustomer.address}, ${lead.serviceCustomer.city}, ${lead.serviceCustomer.state}',  style: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),

                if(lead.notes.isNotEmpty)
                Text('Note : ${lead.notes}',  style: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('Payment Status', style: textStyle12(context),),
                      10.width,

                      Text('( ${lead.paymentStatus} )', style: textStyle12(context, color: Colors.orangeAccent),),
                    ],
                  ),
                  InkWell(onTap: () => null, child: Icon(Icons.share, color: CustomColor.appColor,))
                ],
              ),

              Text(
                'Status: ${lead.paymentMethod.map((method) {
                  switch (method) {
                    case 'pac':
                      return 'Pay After Consultation';
                    case 'cashfree':
                      return 'Cashfree';
                    case 'wallet':
                      return 'Wallet';
                    default:
                      return method;
                  }
                }).join(', ')}',
                style: textStyle12(
                  context,
                  color: CustomColor.descriptionColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
              if (!lead.paymentMethod.contains('pac'))
              Text('Transaction Id : N/A',  style: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),
              Row(
                children: [
                  Text('Price :',  style: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),
                  10.width,
                  CustomAmountText(amount: '${lead.service.price}', fontSize: 12, fontWeight: FontWeight.w400, color: CustomColor.descriptionColor, isLineThrough: true),
                  10.width,
                  CustomAmountText(amount: '${lead.service.discountedPrice}', fontSize: 12, fontWeight: FontWeight.w400, color: CustomColor.descriptionColor),
                ],
              ),
              Divider(thickness: 0.4,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('Wallet :',  style: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),
                      5.width,
                      CustomAmountText(amount: '${lead.walletAmount},', fontSize: 12, fontWeight: FontWeight.w400, color: CustomColor.descriptionColor, isLineThrough: true),
                      20.width,
                      Text('Amount : ',  style: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),
                      if (lead.remainingAmount !=0)
                      CustomAmountText(amount: '${lead.remainingAmount}', fontSize: 12, fontWeight: FontWeight.w400, color: CustomColor.descriptionColor, isLineThrough: true),
                      5.width,
                      CustomAmountText(amount: '${lead.totalAmount}', fontSize: 12, fontWeight: FontWeight.w400, color: CustomColor.descriptionColor),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Pay Now',style: textStyle14(context, color: CustomColor.greenColor),)
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildBookingSummary(BuildContext context, LeadsModel lead){
  return CustomContainer(
    border: true,
    backgroundColor: CustomColor.whiteColor,
    margin: EdgeInsets.zero,
    child: Column(
      spacing: 10,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Price', style:textStyle12(context),),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomAmountText(amount: '${lead.service.price}', isLineThrough: true),
                10.width,
                CustomAmountText(amount:  '00'),
              ],
            ),
          ],
        ),

        _buildRow(context, title: 'Service Discount ( ${lead.serviceDiscount} % )', amount: '- ₹ 00'),
        _buildRow(context, title: 'Coupon Discount ( ${lead.couponDiscount} % )', amount: '- ₹ 00',),
        _buildRow(context, title: 'Campaign Discount ( 0 % )', amount: '- ₹ 00',),
        _buildRow(context, title: 'Service GST ( ${lead.gst} % )', amount: '+ ₹ 00'),
        _buildRow(context, title: 'Platform Fee ( ₹ ${lead.platformFee} )', amount: '+ ₹ 00',),
        _buildRow(context, title: 'Fetch True Assurity Charges ( ₹ ${lead.assurityFee} )', amount: '+ ₹ 00',),
        Divider(thickness: 0.4,),
        _buildRow(context, title: 'Grand Total', amount: '₹ ${lead.totalAmount}',),
      ],
    ),
  );
}

Widget _buildRow(BuildContext context, {required String title, required String amount,}){
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(title, style: textStyle12(context, fontWeight: FontWeight.w400),),
      Text(amount, style: textStyle12(context, fontWeight: FontWeight.w400),),
    ],
  );
}

Widget _buildCommissionCard(BuildContext context){
  return CustomContainer(
    border: true,
    width: double.infinity,
    backgroundColor: CustomColor.whiteColor,
    margin: EdgeInsets.zero,
    child:  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('You Will Earn Commission', style: textStyle14(context, color: CustomColor.appColor),)  ,
        Row(
          children: [
            Text('Up To', style: textStyle12(context),),
            10.width,
            Text('00', style: textStyle14(context, color: Colors.green),),
          ],
        )  ,
      ],
    ),
  );
}

