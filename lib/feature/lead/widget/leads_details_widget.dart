import 'package:fetchtrue/core/widgets/custom_button.dart';
import 'package:fetchtrue/core/widgets/formate_price.dart';
import 'package:fetchtrue/feature/lead/widget/provider_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_amount_text.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../../../helper/Contact_helper.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../../checkout/bloc/payu_gateway/payu_gateway_bloc.dart';
import '../../checkout/model/payu_gateway_model.dart';
import '../../checkout/repository/payu_gateway_repository.dart';
import '../../checkout/screen/payu_open_in_app_view_screen.dart';
import '../../profile/model/user_model.dart';
import '../../wallet/bloc/wallet_bloc.dart';
import '../../wallet/bloc/wallet_event.dart';
import '../../wallet/bloc/wallet_state.dart';
import '../../wallet/repository/wallet_repository.dart';
import '../bloc/lead/lead_bloc.dart';
import '../bloc/lead/lead_event.dart';
import '../bloc/lead/lead_state.dart';
import '../model/lead_model.dart';
import '../repository/checkout_service_buy_repository.dart';
import 'customer_card_widget.dart';
import 'lead_card_widget.dart';

class LeadsDetailsWidget extends StatelessWidget {
  final  String leadId;
  final UserModel user;
  const LeadsDetailsWidget({super.key, required this.leadId, required this.user,});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);

    return BlocBuilder<LeadBloc, LeadState>(
      builder: (context, state) {
        if (state is LeadLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is LeadLoaded) {
          final lead = state.allLeads.firstWhere((l) => l.id == leadId,);

          if (lead == null) {
            return const Center(child: Text("Lead not found"));
          }
          return SingleChildScrollView(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
            child: Column(
              children: [
                SizedBox(height: dimensions.screenHeight*0.01,),

                /// Booking card
                buildBookingCard(context , lead: lead),
                SizedBox(height: dimensions.screenHeight*0.015,),

                _buildCommissionCard(context, lead: lead),
                SizedBox(height: dimensions.screenHeight*0.015,),

                /// Custom details card
                customerDetails(context, lead),
                SizedBox(height: dimensions.screenHeight*0.015,),

                /// Payment status card
                _buildPaymentStatus(context, lead, user),
                SizedBox(height: dimensions.screenHeight*0.015,),

                /// Booking summary card
                _buildBookingSummary(context,lead),
                SizedBox(height: dimensions.screenHeight*0.015,),

                /// Provider Card
                ProviderCardWidget(providerId: lead.provider,),
                50.height
              ],
            ),
          );

        } else if (state is LeadError) {
          print("❌ ${state.message}");
          return const Center(child: Text("No data"));
        }
        return const Center(child: Text("No data"));
      },
    );
  }
}

/// Payment status
Widget _buildPaymentStatus(BuildContext context, LeadModel lead, UserModel user) {
  final userSession = Provider.of<UserSession>(context);

  final paidAmount = lead.paidAmount!;
  final remainingAmount = lead.remainingAmount!;
  final status = lead.paymentStatus;
  String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Colors.green;
      case 'unpaid':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.black;
    }
  }


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
                Text('Payment Status', style: textStyle12(context)),
                10.width,
                Text('( ${capitalize(status!)} )', style: textStyle12(context, color: getStatusColor(status)),)
              ],
            ),

            /// Paid / Remaining Amounts
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                     10.height,
                  if(status == 'paid' || status == 'pending')
                  _buildRow(
                    context,
                    title: 'Paid Amount',
                    amount: '₹ ${formatPrice(paidAmount)}',
                  ),


                  if(status == 'pending' || status == 'unpaid')
                  _buildRow(
                    context,
                    title: 'Remaining Amount',
                    amount: '₹ ${formatPrice(remainingAmount)}',
                  ),
              ],
            ),


            const Divider(),

            /// Pay Now Button
            // if (status == 'unpaid')
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: InkWell(
                  onTap: () {
                    _showPaymentBottomSheet(
                      context,
                      lead, user,
                          () {
                        context.read<LeadBloc>().add(FetchLeadsByUser(userSession.userId!));
                      },
                    );
                  },
                  child: Text(
                    'Pay Now',
                    style: textStyle14(context, color: CustomColor.appColor),
                  ),
                ),
              ),


            /// Remaining Payment Button
            //  if(status == 'pending')
            //   Padding(
            //     padding: const EdgeInsets.only(top: 10),
            //     child: RemainingPaymentButton(lead: lead, user: user,),
            //   ),
          ],
        ),
      ),

      /// Share Button
      if(status != 'paid')
      Positioned(
        top: -5,
        right: 5,
        child: IconButton(
          onPressed: () {
            final userSession = Provider.of<UserSession>(context, listen: false);
            final serviceId = lead.service?.id;
            final userId = (serviceId != null && serviceId.isNotEmpty)
                ? userSession.userId
                : null;

            print('-----------serviceId: $serviceId------userId: $userId---------');

            if (userId != null) {
              final shareUrl =
                  'https://fetchtrue-service-page.vercel.app/?serviceId=$serviceId&userId=$userId';
              Share.share('Check out this service on FetchTrue:\n$shareUrl');
            } else {
              showCustomSnackBar(context, 'Please wait data is loading.');
            }
          },
          icon: Icon(Icons.share, color: CustomColor.appColor),
        ),
      ),
    ],
  );
}


void _showPaymentBottomSheet(
    BuildContext context,
    LeadModel lead,
    UserModel user,
    VoidCallback? onPaymentSuccess,
    ) {
  final dimensions = Dimensions(context);
  final fullAmount = lead.totalAmount!.toDouble();
  final halfAmount = fullAmount / 2;

  // 🧩 Reactive state using ValueNotifier
  final paymentType = ValueNotifier<String>('full');
  final payableAmount = ValueNotifier<double>(fullAmount);
  final isWalletApplied = ValueNotifier<bool>(false);
  double walletBalance = 0;

  showModalBottomSheet(
    context: context,
    isScrollControlled: false,
    backgroundColor: Colors.transparent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (bottomSheetContext) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) =>
            WalletBloc(WalletRepository())..add(FetchWalletByUserId(user.id)),
          ),
          BlocProvider(
            create: (_) => PayUGatewayBloc(PayUGatewayRepository()),
          ),
        ],
        child: BlocBuilder<WalletBloc, WalletState>(
          builder: (context, walletState) {
            if (walletState is WalletLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (walletState is WalletLoaded) {
              walletBalance = walletState.wallet.balance;

              return BlocConsumer<PayUGatewayBloc, PayUGatewayState>(
                listener: (context, payuState) {
                  if (payuState is PayUGatewaySuccess) {
                    final paymentUrl =
                        payuState.response.result?.paymentLink ?? "";
                    if (paymentUrl.isNotEmpty) {
                      openInAppWebView(context, paymentUrl, () {
                        onPaymentSuccess?.call();
                        Navigator.pop(bottomSheetContext, true);
                      });
                    } else {
                      showCustomSnackBar(context, "Payment link not found");
                    }
                  } else if (payuState is PayUGatewayFailure) {
                    showCustomSnackBar(context, payuState.message);
                  }
                },
                builder: (context, payuState) {
                  final isLoading = payuState is PayUGatewayLoading;

                  return ValueListenableBuilder(
                    valueListenable: paymentType,
                    builder: (context, selectedType, _) {
                      return ValueListenableBuilder(
                        valueListenable: payableAmount,
                        builder: (context, amount, _) {
                          return CustomContainer(
                            color: CustomColor.whiteColor,
                            padding:  EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                 Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     Text(
                                       'Service Amount : ₹ ${fullAmount.toStringAsFixed(2)}',
                                       style: textStyle14(context),
                                     ),
                                     10.height,

                                     /// Payment Type Selection
                                     CustomContainer(
                                       margin: EdgeInsets.zero,
                                       child: Row(
                                         mainAxisAlignment:
                                         MainAxisAlignment.spaceBetween,
                                         children: [
                                           _paymentOption(
                                             context,
                                             label: 'Full Payment',
                                             value: 'full',
                                             groupValue: selectedType,
                                             amount: fullAmount,
                                             onSelect: (val) {
                                               paymentType.value = val;
                                               double newAmount = fullAmount;
                                               if (isWalletApplied.value) {
                                                 newAmount = (newAmount -
                                                     walletBalance)
                                                     .clamp(0, double.infinity);
                                               }
                                               payableAmount.value = newAmount;
                                             },
                                           ),
                                           _paymentOption(
                                             context,
                                             label: 'Partial Payment',
                                             value: 'half',
                                             groupValue: selectedType,
                                             amount: halfAmount,
                                             onSelect: (val) {
                                               paymentType.value = val;
                                               double newAmount = halfAmount;
                                               if (isWalletApplied.value) {
                                                 newAmount = (newAmount -
                                                     walletBalance)
                                                     .clamp(0, double.infinity);
                                               }
                                               payableAmount.value = newAmount;
                                             },
                                           ),
                                         ],
                                       ),
                                     ),

                                   ],
                                 ),

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Pay Amount: ₹ ${amount.toStringAsFixed(2)}',
                                        style: textStyle14(context),
                                      ),
                                      SizedBox(
                                        width:
                                        dimensions.screenHeight * 0.15,
                                        child: CustomButton(
                                          isLoading: isLoading,
                                          label: 'Pay Now',
                                          onPressed: () {
                                            final timestamp = DateTime.now()
                                                .millisecondsSinceEpoch;
                                            final orderId =
                                                "checkout_$timestamp";

                                            final payuModel =
                                            PayUGatewayModel(
                                              subAmount: amount,
                                              isPartialPaymentAllowed:
                                              selectedType == 'half',
                                              description:
                                              "Service Payment",
                                              orderId: orderId,
                                              customer: PayUCustomer(
                                                customerId: user.id,
                                                customerName: user.fullName,
                                                customerEmail: user.email,
                                                customerPhone:
                                                user.mobileNumber,
                                              ),
                                              udf: PayUUdf(
                                                udf1: orderId,
                                                udf2: '',
                                                udf3: user.id,
                                              ),
                                            );

                                            context
                                                .read<PayUGatewayBloc>()
                                                .add(CreatePayULinkEvent(
                                                payuModel));
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              );
            } else {
              return const Center(child: Text("Failed to load wallet"));
            }
          },
        ),
      );
    },
  );
}

/// Payment option widget
Widget _paymentOption(
    BuildContext context, {
      required String label,
      required String value,
      required String groupValue,
      required double amount,
      required Function(String) onSelect,
    }) {
  return Row(
    children: [
      Radio<String>(
        value: value,
        groupValue: groupValue,
        activeColor: CustomColor.appColor,
        onChanged: (val) => onSelect(val!),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: textStyle12(context)),
          CustomAmountText(
            amount: amount.toStringAsFixed(2),
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: CustomColor.appColor,
          ),
        ],
      ),
    ],
  );
}



// class RemainingPaymentButton extends StatefulWidget {
//   final LeadModel lead;
//   final UserModel user;
//   const RemainingPaymentButton({super.key, required this.lead, required this.user});
//
//   @override
//   State<RemainingPaymentButton> createState() => _RemainingPaymentButtonState();
// }
//
// class _RemainingPaymentButtonState extends State<RemainingPaymentButton> {
//   bool _isLoading = false;
//
//   @override
//   Widget build(BuildContext context) {
//
//     final now = DateTime.now();
//
//     // Safe Order ID for Payment Gateway
//     final formattedOrderId =
//         "${now.day.toString().padLeft(2, '0')}_"
//         "${now.month.toString().padLeft(2, '0')}_"
//         "${now.year.toString().substring(2)}_"
//         "${now.hour.toString().padLeft(2, '0')}-"
//         "${now.minute.toString().padLeft(2, '0')}-"
//         "${now.second.toString().padLeft(2, '0')}";
//
//     return InkWell(
//       onTap: _isLoading ? null : () async {
//         setState(() {_isLoading = true;});
//
//         final result = await initiateCheckoutServicePayment(
//           context: context,
//           orderId: 'checkout_$formattedOrderId',
//           checkoutId: widget.lead.id.toString(),
//           amount: widget.lead.remainingAmount,
//           customerId: widget.lead.serviceCustomer!.id.toString(),
//           name: widget.user.fullName,
//           phone: widget.user.mobileNumber,
//           email: widget.user.email,
//         );
//
//         setState(() {
//           _isLoading = false;
//         });
//
//         if (result == true) {
//           context.read<LeadBloc>().add(FetchLeadsByUser(widget.user.id));
//         }
//       },
//       child: _isLoading
//           ? SizedBox(
//         height: 20,
//         width: 20,
//         child: CircularProgressIndicator(
//           color: CustomColor.appColor,
//           strokeWidth: 2.0,
//         ),
//       )
//           : Text(
//         'Pay Now',
//         style: textStyle14(context, color: CustomColor.appColor),
//       ),
//     );
//   }
// }

Widget _buildBookingSummary(BuildContext context, LeadModel lead) {

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
          amount: '₹ ${lead.listingPrice?.toStringAsFixed(2)}',
        ),
        _buildRow(
          context,
          title: 'Service Discount (${lead.service!.discount}%)',
          amount: '- ₹ ${lead.serviceDiscountPrice?.toStringAsFixed(2)}',
        ),
        _buildRow(
          context,
          title: 'Price After Discount',
          amount: '₹ ${lead.service!.discountedPrice?.toStringAsFixed(2)}',
        ),

        if(lead.couponDiscount!=0)
        _buildRow(
          context,
          title: 'Coupon Discount (${lead.couponDiscount}${lead.couponDiscountType})',
          amount: '- ₹ ${lead.couponDiscountPrice?.toStringAsFixed(2)}',
        ),
        _buildRow(
          context,
          title: 'Service GST (${lead.gst}%)',
          amount: '+ ₹ ${lead.serviceGSTPrice?.toStringAsFixed(2)}',
        ),
        _buildRow(
          context,
          title: 'Platform Fee (₹ ${lead.platformFee})',
          amount: '+ ₹ ${lead.platformFeePrice?.toStringAsFixed(2)}',
        ),
        _buildRow(
          context,
          title: 'Fetch True Assurity Charges (${lead.assurityfee} %)',
          amount: '+ ₹ ${lead.assurityChargesPrice?.toStringAsFixed(2)}',
        ),
        Divider(thickness: 0.4),
        _buildRow(
          context,
          title: 'Grand Total',
          amount: '₹ ${lead.totalAmount?.toStringAsFixed(0)}',
          // amount: '₹ ${formatPrice(lead.totalAmount)}',
        ),
      ],
    ),
  );
}

Widget _buildRow(BuildContext context, {required String title, required String amount,}){
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(title, style: textStyle12(context,fontWeight: FontWeight.w400),),
      Text(amount, style: textStyle12(context,fontWeight: FontWeight.w400),),
    ],
  );
}

Widget _buildCommissionCard(BuildContext context, { required LeadModel lead}){

  String formatCommission(dynamic rawCommission, {bool half = false}) {
    if (rawCommission == null) return '0';

    final commissionStr = rawCommission.toString();

    // Extract numeric value
    final numericStr = commissionStr.replaceAll(RegExp(r'[^0-9.]'), '');
    final numeric = double.tryParse(numericStr) ?? 0;

    // Extract symbol (₹, %, etc.)
    final symbol = RegExp(r'[^\d.]').firstMatch(commissionStr)?.group(0) ?? '';

    final value = half ? (numeric / 2).round() : numeric.round();

    // Format with symbol
    if (symbol == '%') {
      return '$value%';
    } else {
      return '$symbol$value';
    }
  }

  return CustomContainer(
    border: true,
    width: double.infinity,
    color: CustomColor.whiteColor,
    margin: EdgeInsets.zero,
    child:  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('You Will Earn Commission', style: textStyle12(context, color: CustomColor.appColor),)  ,
        Row(
          children: [
            Text('Up To', style: textStyle12(context),),
            10.width,
            Text(formatCommission(lead.commission.toString(), half: true),
              // lead.commission.toString(),
              style: textStyle14(context, color: Colors.green),
            ),

          ],
        )  ,
      ],
    ),
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