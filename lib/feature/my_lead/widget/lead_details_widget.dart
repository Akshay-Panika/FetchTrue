import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_icon.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_amount_text.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../helper/Contact_helper.dart';

class LeadDetailsWidget extends StatefulWidget {
  final Dimensions dimensions;
  const LeadDetailsWidget({super.key, required this.dimensions});

  @override
  State<LeadDetailsWidget> createState() => _LeadDetailsWidgetState();
}

class _LeadDetailsWidgetState extends State<LeadDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return   Column(
      children: [

        /// Booking card
        _buildBookingCard(context),
        SizedBox(height: widget.dimensions.screenHeight*0.015,),

        /// Custom details card
        _customerDetails(context),
        SizedBox(height: widget.dimensions.screenHeight*0.015,),


        /// Payment status card
        _buildPaymentStatus(context),
        SizedBox(height: widget.dimensions.screenHeight*0.015,),

        /// Booking summary card
        _buildBookingSummary(context),
        SizedBox(height: widget.dimensions.screenHeight*0.015,),

        CustomContainer(
          width: double.infinity,
          backgroundColor: CustomColor.greenColor.withOpacity(0.1),
          margin: EdgeInsets.zero,
          child: Text('You Will Earn ₹000\nCommission From This Product', style: textStyle14(context, fontWeight: FontWeight.w400, color: CustomColor.appColor),textAlign: TextAlign.center,),),
        SizedBox(height: widget.dimensions.screenHeight*0.015,),


        Padding(
          padding:  EdgeInsets.all(widget.dimensions.screenHeight*0.015),
          child: CustomButton(label: 'Pay Now',onPressed: () => null,),
        ),

      ],
    );
  }
}

/// Booking card
Widget _buildBookingCard(BuildContext context){
  return CustomContainer(
    border: false,
    backgroundColor: Colors.white,
    margin: EdgeInsets.zero,
    child: Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Service Name',
                  style:  textStyle14(context),
                ),
                Text('Lead Id: #0156nk', style:  textStyle12(context,color: CustomColor.descriptionColor),),
              ],
            ),
            _buildStatusBadge(context,'Pending'),
          ],
        ),

        _iconText(icon: Icons.calendar_month, text: 'Timing Details : 6 May 2025 08:50 PM'),
        _iconText(icon: Icons.calendar_month, text: 'Services Schedule Date : 6 May 2025 08:50 PM'),
        _iconText(icon: Icons.location_on_outlined, text: 'Address : Office ve jkw 3br#429, Amanora Chambers Pune'),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('OTP: FT00001',textAlign: TextAlign.center,style: textStyle14(context,fontWeight: FontWeight.w400),),
            CustomContainer(
              backgroundColor: Colors.blue.shade50,
              padding: EdgeInsetsDirectional.symmetric(vertical: 4, horizontal: 10),
              child: Text('Download Invoice', style: textStyle12(context, color: CustomColor.appColor),),),
          ],
        )
      ],
    ),
  );
}

Widget _iconText({double? fontSize, IconData? icon, double? iconSize,Color? iconColor, String? text, Color? textColor,FontWeight? fontWeight}){
  return Row(
    spacing: 10,
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Icon(icon!, size: iconSize ?? 14,color: iconColor ?? Colors.grey,),
      Expanded(child: Text(text!, style: TextStyle(fontSize: fontSize  ?? 12, color: textColor ?? CustomColor.descriptionColor, fontWeight: fontWeight ??FontWeight.w400),))
      // textStyle12(context,color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),
    ],
  );
}

/// Status
Widget _buildStatusBadge(BuildContext context,String status) {
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
        5.width,
        Text(
          status, style: textStyle12(context, color: color,),),
      ],
    ),
  );
}


Widget _customerDetails(BuildContext context){
  final phoneNumber = '918989207770';
  final message = 'Hello, I am contacting you from BizBooster 2X.';

  return CustomContainer(
    border: false,
    backgroundColor: Colors.white,
    margin: EdgeInsets.zero,
    child: Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _iconText(
              icon: Icons.person,
              iconSize: 16,
              iconColor: CustomColor.appColor,
              text: 'Customer Details',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              textColor: Colors.black,),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name :', style: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),
                Text('Phone :',  style: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),
              ],
            ),

            Text('Address: Waidhan Singrauli MP',  style: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),
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


Widget _buildPaymentStatus(BuildContext context){
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
              _iconText(
                  fontWeight: FontWeight.w500,
                  icon: Icons.currency_rupee, iconColor: CustomColor.appColor,
                  text: 'Payment Status',textColor: Colors.black
              ),

              // SizedBox(height: 10,),
              Text('Payment after consultation/Partial/Full Payment', style: textStyle14(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),
              Text('Transaction Id : #bfuicrw hu4g5g54hg5',  style: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),
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

Widget _buildBookingSummary(BuildContext context){
  return CustomContainer(
    border: false,
    backgroundColor: Colors.white,
    margin: EdgeInsets.zero,
    child: Column(
      spacing: 10,
      children: [
        _buildRow(context,label: 'Sub Total', value: '5,999.00' ),
        _buildRow(context,label: 'Service Discount', value: '00' ),
        _buildRow(context, label: 'Coupon Discount', value: '00' ),
        _buildRow(context ,label: 'Campaign Discount', value: '00' ),
        Divider(),
        _buildRow(context,label: 'Grand Total', value: '00' , textColor: CustomColor.appColor),
      ],
    ),
  );
}

Widget _buildRow(BuildContext context,{String? label, Color? textColor, String? value}){
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label!, style: textStyle12(context,color: textColor ?? CustomColor.descriptionColor),),
      CustomAmountText(amount: value!, color: textColor ?? CustomColor.descriptionColor, fontSize: 14),
    ],
  );
}

