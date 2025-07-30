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

  String getPaymentStatus(LeadsModel lead) {
    final paid = lead.paidAmount;
    final remaining = lead.remainingAmount;

    if ((paid == null || paid == 0) && (remaining == null || remaining == 0)) {
      return 'Unpaid';
    } else if (paid != null && paid > 0 && remaining != null && remaining > 0) {
      return 'Pending';
    } else if (paid != null && paid > 0 && (remaining == null || remaining == 0)) {
      return 'Paid';
    } else {
      return 'Unpaid';
    }
  }

  Color getPaymentStatusColor(String status) {
    switch (status) {
      case 'Paid':
        return Colors.green;
      case 'Pending':
        return Colors.orangeAccent;
      case 'Unpaid':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  final status = getPaymentStatus(lead);
  final statusColor = getPaymentStatusColor(status);
  return CustomContainer(
    border: true,
    backgroundColor: Colors.white,
    margin: EdgeInsets.zero,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Payment Status', style: textStyle12(context),),
            10.width,
            Text('( $status )', style: textStyle12(context, color: statusColor),),
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
          style: textStyle12(context, fontWeight: FontWeight.w400),
        ),
        if (!lead.paymentMethod.contains('pac'))
        Text('Transaction Id : N/A',  style: textStyle12(context, fontWeight: FontWeight.w400),),
        Divider(thickness: 0.4,),

        Column(
          spacing: 10,
          children: [
            if (lead.walletAmount !=0)
            _buildRow(
              context,
              title: 'Wallet Amount',
              amount: '₹ ${lead.walletAmount}',
            ),

            if (lead.paidAmount !=0)
            _buildRow(
              context,
              title: 'Paid Amount',
              amount: '₹ ${lead.paidAmount}',
            ),

            if (lead.remainingAmount !=0)
            _buildRow(
              context,
              title: 'Remaining Amount',
              amount: '₹ ${lead.remainingAmount}',
            ),
          ],
        ),
        10.height,

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Text('Share Link',style: textStyle14(context, color: CustomColor.appColor),),
            Text('Pay Now',style: textStyle14(context, color: CustomColor.greenColor),),
          ],
        ),
      ],
    ),
  );
}

Widget _buildBookingSummary(BuildContext context, LeadsModel lead) {
  String formatPrice(num? value) {
    if (value == null) return '0'; // या 'N/A' या कुछ भी fallback
    return value.round().toString();
  }


  return CustomContainer(
    border: true,
    backgroundColor: CustomColor.whiteColor,
    margin: EdgeInsets.zero,
    child: Column(
      spacing: 10,
      children: [
        _buildRow(
          context,
          title: 'Listing Price',
          // amount: '₹ ${lead.listingPrice}',
          amount: '₹ ${formatPrice(lead.listingPrice)}',
        ),
        _buildRow(
          context,
          title: 'Service Discount (${lead.service.discount}%)',
          // amount: '- ₹ ${lead.serviceDiscountPrice}',
          amount: '- ₹ ${formatPrice(lead.serviceDiscountPrice)}',

        ),
        _buildRow(
          context,
          title: 'Price After Discount',
          // amount: '₹ ${lead.service.discountedPrice}',
          amount: '₹ ${formatPrice(lead.service.discountedPrice)}',

        ),
        _buildRow(
          context,
          title: 'Coupon Discount (₹ ${lead.couponDiscount})',
          // amount: '- ₹ ${lead.couponDiscountPrice}',
          amount: '- ₹ ${formatPrice(lead.couponDiscountPrice)}',

        ),
        _buildRow(
          context,
          title: 'Service GST (${lead.gst}%)',
          // amount: '+ ₹ ${lead.serviceGSTPrice}',
          amount: '+ ₹ ${formatPrice(lead.serviceGSTPrice)}',

        ),
        _buildRow(
          context,
          title: 'Platform Fee (${lead.platformFee}%)',
          // amount: '+ ₹ ${lead.platformFeePrice}',
          amount: '+ ₹ ${formatPrice(lead.platformFeePrice)}',

        ),
        _buildRow(
          context,
          title: 'Fetch True Assurity Charges (${lead.assurityFee}%)',
          // amount: '+ ₹ ${lead.assurityChargesPrice}',
          amount: '+ ₹ ${formatPrice(lead.assurityChargesPrice)}',

        ),
        Divider(thickness: 0.4),
        _buildRow(
          context,
          title: 'Grand Total',
          // amount: '₹ ${lead.totalAmount}',
          amount: '₹ ${formatPrice(lead.totalAmount)}',
        ),
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

