import 'package:fetchtrue/core/widgets/custom_button.dart';
import 'package:fetchtrue/core/widgets/formate_price.dart';
import 'package:fetchtrue/feature/my_lead/widget/provider_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_icon.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_amount_text.dart';
import '../../../core/widgets/custom_bottom_sheet.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../../../helper/Contact_helper.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../../checkout/repository/service_buy_repository.dart';
import '../model/leads_model.dart';
import '../repository/checkout_service_buy_repository.dart';
import '../repository/download_invoice_service.dart';
import '../repository/lead_by_user_service.dart';

class LeadsDetailsWidget extends StatefulWidget {
  final String userId;
  final String checkoutId;
  const LeadsDetailsWidget({super.key, required this.checkoutId, required this.userId});

  @override
  State<LeadsDetailsWidget> createState() => _LeadsDetailsWidgetState();
}

class _LeadsDetailsWidgetState extends State<LeadsDetailsWidget> {

  LeadsModel? lead;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCheckoutData();
  }

  Future<void> _refreshData() async {
    setState(() {
      isLoading = true;
    });

    await fetchCheckoutData();
  }

  Future<void> fetchCheckoutData() async {
    final data = await LeadByUserService.fetchCheckoutById(
      widget.userId,
      widget.checkoutId,
    );

    if (!mounted) return;

    setState(() {
      lead = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    if (isLoading) {
      return Align(
          alignment: Alignment.topCenter,
          child: LinearProgressIndicator(color: CustomColor.appColor,minHeight: 2,));
    }

    if (lead == null) {
      return const Center(child: Text("No lead data available"));
    }
    return  RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
        child: Column(
          children: [
            SizedBox(height: dimensions.screenHeight*0.01,),

            /// Booking card
            _buildBookingCard(context , lead: lead!),
            SizedBox(height: dimensions.screenHeight*0.015,),

            _buildCommissionCard(context, lead: lead!),
            SizedBox(height: dimensions.screenHeight*0.015,),

            /// Custom details card
            _customerDetails(context, lead!),
            SizedBox(height: dimensions.screenHeight*0.015,),


            /// Payment status card
            _buildPaymentStatus(context, lead!, _refreshData),
            SizedBox(height: dimensions.screenHeight*0.015,),

            /// Booking summary card
            _buildBookingSummary(context,lead!),
            SizedBox(height: dimensions.screenHeight*0.015,),

            /// Provider Card
            ProviderCardWidget(lead:lead!),
            50.height
          ],
        ),
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
    color: Colors.white,
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
    color: Colors.white,
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
                Text('Name : ${lead.serviceCustomer.fullName}', style:  textStyle12(context, fontWeight: FontWeight.w400)),
                Text('Phone : ${lead.serviceCustomer.phone}',  style:  textStyle12(context, fontWeight: FontWeight.w400)),
                // Text('Email Id : ${lead.serviceCustomer!.email}',  style: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),
                Text('Address: ${lead.serviceCustomer.address}, ${lead.serviceCustomer.city}, ${lead.serviceCustomer.state}',  style:  textStyle12(context, fontWeight: FontWeight.w400)),

                if(lead.notes.isNotEmpty)
                Text('Note : ${lead.notes}',  style:  textStyle12(context, fontWeight: FontWeight.w400)),
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
Widget _buildPaymentStatus(BuildContext context, LeadsModel lead, VoidCallback? onPaymentSuccess){
  final status = lead.paidAmount == 0
      ? 'Unpaid' : (lead.remainingAmount != 0 ? 'Pending' : 'Paid');

  // final status =  lead.paidAmount !=0 ? 'Paid' : (lead.paidAmount !=0 && lead.remainingAmount !=0) ?'Pending':'Unpaid';
    return Stack(
    children: [
      CustomContainer(
        border: true,
        color: Colors.white,
        margin: EdgeInsets.zero,
        child: Column(
          children: [
            Row(
              children: [
                Text('Payment Status', style: textStyle12(context),),
                10.width,
                Text('( $status )', style: textStyle12(context, color: status == 'Paid'? CustomColor.appColor:status == 'Unpaid'? CustomColor.redColor : CustomColor.amberColor),),
              ],
            ),
            Divider(),


            Column(
             spacing: 5,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   'Payment Method: ${lead.paymentMethod.map((method) {
                //     switch (method) {
                //       case 'pac':
                //         return 'Pay After Consultation';
                //       case 'cashfree':
                //         return 'Cashfree';
                //       case 'wallet':
                //         return 'Wallet';
                //       default:
                //         return method;
                //     }
                //   }).join(', ')}',
                //   style: textStyle12(context, fontWeight: FontWeight.w400),
                // ),

                if(lead.paidAmount!=0)
                 _buildRow(context, title: 'Paid Amount', amount: '₹ ${formatPrice(lead.paidAmount)}',),
                if(lead.remainingAmount !=0)
                _buildRow(context, title: 'Remaining Amount', amount: '₹ ${formatPrice(lead.remainingAmount)}',),
              ],
            ),


            Column(
              children: [
                if(lead.paidAmount ==0 && '${getLeadStatus(lead)}' != 'Cancel')
                  Padding(
                    padding: EdgeInsetsGeometry.only(top: 10),
                    child: InkWell(
                      child: Text('Pay Now', style: textStyle14(context, color: CustomColor.appColor),),
                      onTap: () {
                        _showPaymentBottomSheet(context,lead, onPaymentSuccess);
                      },
                    ),
                  ),
              ],
            ),


            /// Remaining Pay
            if(lead.paidAmount !=0 && lead.remainingAmount!=0)
            Padding(
              padding: EdgeInsetsGeometry.only(top: 10),
              child: RemainingPaymentButton(lead: lead,onPaymentSuccess: onPaymentSuccess,),
            ),

          ],
        ),
      ),

      Positioned(
          top: -5,
          right: 5,
          child: IconButton(
              onPressed: () {
                final userSession = Provider.of<UserSession>(context, listen: false);
                final serviceId =lead.service.id;
                final userId = serviceId.isNotEmpty ?  userSession.userId: null;

                print('-----------serviceId: $serviceId------userId: $userId---------');

                if (userId != null) {
                  final shareUrl = 'https://fetchtrue-service-page.vercel.app/?serviceId=$serviceId&userId=$userId';
                  Share.share('Check out this service on FetchTrue:\n$shareUrl');
                } else {
                  showCustomSnackBar(context,  'Please wait data is loading.');
                }
              },
              icon: Icon(Icons.share,color: CustomColor.appColor,)))
    ],
  );
}


void _showPaymentBottomSheet(BuildContext context, LeadsModel lead, VoidCallback? onPaymentSuccess) {

  double fullAmount = lead.totalAmount.toDouble();
  double halfAmount = fullAmount / 2;
  double walletBalance = 100.0;

  ValueNotifier<String> paymentType = ValueNotifier('full');
  ValueNotifier<double> payableAmount = ValueNotifier(fullAmount);
  ValueNotifier<bool> isWalletApplied = ValueNotifier(false);
  bool _isLoading = false;
  final now = DateTime.now();
  final formattedOrderId =
      "${now.day.toString().padLeft(2, '0')}/"
      "${now.month.toString().padLeft(2, '0')}/"
      "${now.year.toString().substring(2)}/_"
      "${now.hour.toString().padLeft(2, '0')}:"
      "${now.minute.toString().padLeft(2, '0')}:"
      "${now.second.toString().padLeft(2, '0')}";

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: false,
    backgroundColor: WidgetStateColor.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext bottomSheetContext) {
      return DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: StatefulBuilder(
              builder: (context, setState) {
                return CustomContainer(
                  color: CustomColor.whiteColor,
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text('Service Amount : ₹ $fullAmount', style: textStyle16(context)),
                      const SizedBox(height: 10),

                      /// Wallet Container
                      CustomContainer(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomAmountText(
                                  amount: '${walletBalance.toStringAsFixed(2)}',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: CustomColor.appColor,
                                ),
                                Text('Wallet Balance', style: textStyle12(context)),
                              ],
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  isWalletApplied.value = !isWalletApplied.value;
                                  if (isWalletApplied.value) {
                                    payableAmount.value = (payableAmount.value - walletBalance).clamp(0, double.infinity);
                                  } else {
                                    payableAmount.value = paymentType.value == 'full' ? fullAmount : halfAmount;
                                  }
                                });
                              },
                              child: Text(isWalletApplied.value ? 'Remove' : 'Apply'),
                            )
                          ],
                        ),
                      ),

                      /// Payment Type
                      CustomContainer(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            /// Full Payment
                            Row(
                              children: [
                                Radio<String>(
                                  value: 'full',
                                  groupValue: paymentType.value,
                                  activeColor: CustomColor.appColor,
                                  onChanged: (value) {
                                    setState(() {
                                      paymentType.value = value!;
                                      payableAmount.value = fullAmount;
                                      if (isWalletApplied.value) {
                                        payableAmount.value = (payableAmount.value - walletBalance).clamp(0, double.infinity);
                                      }
                                    });
                                  },
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Full Payment', style: textStyle14(context)),
                                    CustomAmountText(
                                      amount: fullAmount.toStringAsFixed(2),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: CustomColor.appColor,
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            /// Partial Payment
                            Row(
                              children: [
                                Radio<String>(
                                  value: 'half',
                                  groupValue: paymentType.value,
                                  activeColor: CustomColor.appColor,
                                  onChanged: (value) {
                                    setState(() {
                                      paymentType.value = value!;
                                      payableAmount.value = halfAmount;
                                      if (isWalletApplied.value) {
                                        payableAmount.value = (payableAmount.value - walletBalance).clamp(0, double.infinity);
                                      }
                                    });
                                  },
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Partial Payment', style: textStyle14(context)),
                                    CustomAmountText(
                                      amount: halfAmount.toStringAsFixed(2),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: CustomColor.appColor,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 100),

                      /// Final Amount and Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ValueListenableBuilder<double>(
                            valueListenable: payableAmount,
                            builder: (context, value, _) {
                              return Text(
                                'Pay Amount: ₹ ${value.toStringAsFixed(2)}',
                                style: textStyle14(context),
                              );
                            },
                          ),
                          SizedBox(
                            width: 150,
                            child: StatefulBuilder(
                              builder: (context, innerSetState) {
                                return CustomButton(
                                    isLoading: _isLoading,
                                    label: 'Pay Now',
                                    onPressed: () async {
                                      // innerSetState(() => isLoading = true);
                                      setState(() => _isLoading = true);

                                      final result = await initiateCheckoutServicePayment(
                                        context: context,
                                        orderId: 'checkout_$formattedOrderId',
                                        checkoutId: lead.id,
                                        amount: payableAmount.value.toInt(),
                                        customerId: lead.serviceCustomer.id,
                                        name: 'Akshay',
                                        phone: '8989207770',
                                        email: 'akshay@gmail.com',
                                      );

                                      setState(() => _isLoading = false);
                                      // innerSetState(() => isLoading = false);

                                      if (result == true) {
                                        onPaymentSuccess?.call();
                                        Navigator.pop(bottomSheetContext, true);
                                      }
                                    }
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      );
    },
  );
}

class RemainingPaymentButton extends StatefulWidget {
  final LeadsModel lead;
  final VoidCallback? onPaymentSuccess;

  const RemainingPaymentButton({super.key, this.onPaymentSuccess, required this.lead});

  @override
  State<RemainingPaymentButton> createState() => _RemainingPaymentButtonState();
}

// class _RemainingPaymentButtonState extends State<RemainingPaymentButton> {
//   bool _isLoading = false;
//
//   @override
//   Widget build(BuildContext context) {
//
//     final now = DateTime.now();
//     final formattedOrderId =
//         "${now.day.toString().padLeft(2, '0')}/"
//         "${now.month.toString().padLeft(2, '0')}/"
//         "${now.year.toString().substring(2)}/_"
//         "${now.hour.toString().padLeft(2, '0')}:"
//         "${now.minute.toString().padLeft(2, '0')}:"
//         "${now.second.toString().padLeft(2, '0')}";
//
//     return InkWell(
//       onTap: _isLoading
//           ? null
//           : () async {
//         setState(() {
//           _isLoading = true;
//         });
//
//         final result = await initiateCheckoutServicePayment(
//           context: context,
//           orderId: 'checkout_$formattedOrderId',
//           checkoutId: widget.lead.id,
//           amount: widget.lead.remainingAmount.toDouble(),
//           customerId: widget.lead.serviceCustomer.id,
//           name: 'Akshay',
//           phone: '8989207770',
//           email: 'akshay@gmail.com',
//         );
//
//         setState(() {
//           _isLoading = false;
//         });
//
//         if (result == true) {
//           // print("Payment Success");
//           widget.onPaymentSuccess?.call();
//         }
//       },
//       child: _isLoading
//           ?  SizedBox(
//         height: 20,
//         width: 20,
//         child: CircularProgressIndicator(
//           color: CustomColor.appColor,
//         ),
//       )
//           :  Text('Pay Now', style: textStyle14(context, color: CustomColor.appColor),),
//     );
//   }
// }

class _RemainingPaymentButtonState extends State<RemainingPaymentButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    // Safe Order ID for Payment Gateway
    final formattedOrderId =
        "${now.day.toString().padLeft(2, '0')}_"
        "${now.month.toString().padLeft(2, '0')}_"
        "${now.year.toString().substring(2)}_"
        "${now.hour.toString().padLeft(2, '0')}-"
        "${now.minute.toString().padLeft(2, '0')}-"
        "${now.second.toString().padLeft(2, '0')}";

    return InkWell(
      onTap: _isLoading
          ? null
          : () async {
        setState(() {
          _isLoading = true;
        });

        // Round the remaining amount to avoid float issues
        final roundedAmount = double.parse(
          widget.lead.remainingAmount.toStringAsFixed(2),
        );

        final result = await initiateCheckoutServicePayment(
          context: context,
          orderId: 'checkout_$formattedOrderId',
          checkoutId: widget.lead.id,
          amount: roundedAmount.round(),
          customerId: widget.lead.serviceCustomer.id,
          name: 'Akshay',
          phone: '8989207770',
          email: 'akshay@gmail.com',
        );

        setState(() {
          _isLoading = false;
        });

        if (result == true) {
          widget.onPaymentSuccess?.call();
        }
      },
      child: _isLoading
          ? SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          color: CustomColor.appColor,
          strokeWidth: 2.0,
        ),
      )
          : Text(
        'Pay Now',
        style: textStyle14(context, color: CustomColor.appColor),
      ),
    );
  }
}


Widget _buildBookingSummary(BuildContext context, LeadsModel lead) {
  String formatPrice(num? value) {
    if (value == null) return '0'; // या 'N/A' या कुछ भी fallback
    return value.round().toString();
  }


  return CustomContainer(
    border: true,
    color: CustomColor.whiteColor,
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
          title: 'Platform Fee (₹ ${lead.platformFee})',
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

Widget _buildCommissionCard(BuildContext context, { required LeadsModel lead}){

  return CustomContainer(
    border: true,
    width: double.infinity,
    color: CustomColor.whiteColor,
    margin: EdgeInsets.zero,
    child:  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('You Will Earn Commission', style: textStyle14(context, color: CustomColor.appColor),)  ,
        Row(
          children: [
            Text('Up To', style: textStyle12(context),),
            10.width,
            Text(
              lead.commission,
              style: textStyle14(context, color: Colors.green),
            ),

          ],
        )  ,
      ],
    ),
  );
}
