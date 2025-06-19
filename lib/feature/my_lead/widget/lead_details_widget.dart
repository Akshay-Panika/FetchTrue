import 'package:fetchtrue/core/costants/custom_image.dart';
import 'package:fetchtrue/feature/provider/screen/provider__details_screen.dart';
import 'package:fetchtrue/feature/provider/screen/provider_screen.dart';
import 'package:fetchtrue/feature/service/widget/service_review_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_icon.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_amount_text.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../helper/Contact_helper.dart';
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

        /// Booking card
        _buildBookingCard(context, widget.lead),
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
              TextSpan(text: '₹ 0.00', style: textStyle16(context,color: CustomColor.greenColor)),
              WidgetSpan(child: 5.width),
              TextSpan(text: 'Commission From This Product', style: textStyle16(context, color: CustomColor.appColor)),
            ]
          )),),
        SizedBox(height: widget.dimensions.screenHeight*0.02,),


        /// Provider Card
        _buildProviderCard(context, widget.lead),
        SizedBox(height: widget.dimensions.screenHeight*0.015,),


        Padding(
          padding:  EdgeInsets.all(widget.dimensions.screenHeight*0.015),
          child: CustomButton(label: 'Pay Now',onPressed: () => null,),
        ),
        SizedBox(height: widget.dimensions.screenHeight*0.015,),

      ],
    );
  }
}

/// Booking card
Widget _buildBookingCard(BuildContext context,  LeadModel lead){
  return CustomContainer(
    border: false,
    backgroundColor: Colors.white,
    margin: EdgeInsets.zero,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(lead.service.serviceName, style:  textStyle14(context,),),
                Text('Lead Id: #${lead.bookingId}', style:  textStyle14(context,color: CustomColor.descriptionColor),),
              ],
            ),
            _buildStatusBadge(context,'Pending'),
          ],
        ),

        Text('Booking Date : ${DateFormat('dd-MM-yyyy, hh:mm a').format(DateTime.parse(lead.createdAt))}',style:  textStyle14(context,color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),
        Text('Service Date : ', style: textStyle14(context,color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),
        1.height,

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('OTP: FT00001',textAlign: TextAlign.center,style: textStyle14(context,fontWeight: FontWeight.w400),),
            CustomContainer(
              backgroundColor: Colors.blue.shade50,
              padding: EdgeInsetsDirectional.symmetric(vertical: 4, horizontal: 10),
              margin: EdgeInsets.zero,
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


/// Customer details
Widget _customerDetails(BuildContext context, LeadModel lead){
  final phoneNumber = lead.serviceCustomer.phone;
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
                Text('Name : ${lead.serviceCustomer.fullName}', style: textStyle14(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),
                Text('Phone : ${lead.serviceCustomer.phone}',  style: textStyle14(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),
                Text('Address: ${lead.serviceCustomer.city}',  style: textStyle14(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),

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
              _iconText(
                icon: Icons.currency_rupee,
                iconSize: 16,
                iconColor: CustomColor.appColor,
                text: 'Payment Status',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                textColor: Colors.black,),


              // SizedBox(height: 10,),
              Text('Payment after consultation/Partial/Full Payment', style: textStyle14(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),
              Text('Transaction Id : #bfuicrw hu4g5g54hg5',  style: textStyle14(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),
            ],
          ),
        ),

        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          spacing: 20,
          children: [
            Text('${lead.orderStatus}', style: TextStyle(color: CustomColor.appColor, fontWeight: FontWeight.w500),),
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
        _buildRow(context ,label: 'Guarantee Fee', value: '${lead.garrentyFee}'),
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
      Text(label!, style: textStyle14(context,color: textColor ?? CustomColor.descriptionColor),),
      CustomAmountText(amount: value!, color: textColor ?? CustomColor.descriptionColor, fontSize: 14),
    ],
  );
}

/// Provider Card
Widget _buildProviderCard(BuildContext context, LeadModel lead){
  return CustomContainer(
    backgroundColor: CustomColor.whiteColor,
    margin: EdgeInsets.zero,
    child: Column(
      children: [
        InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProviderDetailsScreen(),)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Service Provider', style: textStyle14(context),),
              10.height,
          
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(radius: 25,
                        backgroundImage: AssetImage(CustomImage.nullImage),),
                      10.width,
          
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Provider Name'),
                          Text('Module Name')
                        ],
                      )
                    ],
                  ),
          
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(onTap: () => ContactHelper.whatsapp('', ''),
                            child: Image.asset(CustomIcon.whatsappIcon, height: 25,)),
                        40.width,
                        InkWell(onTap: () => ContactHelper.call(''),
                            child: Image.asset(CustomIcon.phoneIcon, height: 25, color: CustomColor.appColor,)),
          
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),

        15.height,
        Divider(),
        15.height,

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Service Manager', style: textStyle14(context),),
            10.height,

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(radius: 25,
                      backgroundImage: AssetImage(CustomImage.nullImage),),
                    10.width,

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Manager Id'),
                        Text('Manager Name')
                      ],
                    )
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(onTap: () => ContactHelper.whatsapp('', ''),
                          child: Image.asset(CustomIcon.whatsappIcon, height: 25,)),
                      40.width,
                      InkWell(onTap: () => ContactHelper.call(''),
                          child: Image.asset(CustomIcon.phoneIcon, height: 25, color: CustomColor.appColor,)),

                    ],
                  ),
                )
              ],
            ),
          ],
        )
      ],
    ),
  );
}

