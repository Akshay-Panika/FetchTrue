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
import '../../auth/user_notifier/user_notifier.dart';
import '../../wallet/bloc/wallet_bloc.dart';
import '../../wallet/bloc/wallet_state.dart';
import '../bloc/lead/lead_bloc.dart';
import '../bloc/lead/lead_event.dart';
import '../bloc/lead/lead_state.dart';
import '../model/lead_model.dart';
import '../repository/checkout_service_buy_repository.dart';
import 'customer_card_widget.dart';
import 'lead_card_widget.dart';

class LeadsDetailsWidget extends StatelessWidget {
  final  String leadId;
  const LeadsDetailsWidget({super.key, required this.leadId,});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);

    return BlocBuilder<LeadBloc, LeadState>(
      builder: (context, state) {
        if (state is LeadLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is LeadLoaded) {
          final lead = state.leadModel.data?.firstWhere((l) => l.id == leadId,);

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
                _buildPaymentStatus(context, lead),
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
Widget _buildPaymentStatus(BuildContext context, BookingData lead) {
  final userSession = Provider.of<UserSession>(context);

  final paidAmount = lead.paidAmount!.toStringAsFixed(2);
  final remainingAmount = lead.remainingAmount!.toStringAsFixed(2);
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
            const Divider(),

            /// Paid / Remaining Amounts
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                  if(status == 'paid')
                  _buildRow(
                    context,
                    title: 'Paid Amount',
                    amount: '₹ ${paidAmount}',
                  ),

                  if(status == 'pending')
                  _buildRow(
                    context,
                    title: 'Remaining Amount',
                    amount: '₹ ${remainingAmount}',
                  ),
              ],
            ),

            /// Pay Now Button
            if (status == 'unpaid')
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: InkWell(
                  onTap: () {
                    _showPaymentBottomSheet(
                      context,
                      lead,
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
             if(status == 'pending')
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: RemainingPaymentButton(lead: lead),
              ),
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

void _showPaymentBottomSheet(BuildContext context, BookingData lead, VoidCallback? onPaymentSuccess) {

  Dimensions dimensions = Dimensions(context);

  double fullAmount = lead.totalAmount!.toDouble();
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
                      Text(
                        'Service Amount : ₹ ${fullAmount.toStringAsFixed(2)}',
                        style: textStyle14(context),
                      ),
                      const SizedBox(height: 10),

                      /// Wallet Container
                      BlocBuilder<WalletBloc, WalletState>(
                        builder: (context, state) {
                          if (state is WalletLoading) {
                            return  CircularProgressIndicator();
                          } else if (state is WalletLoaded) {
                            final wallet = state.wallet;
                            return  CustomContainer(
                              margin: EdgeInsets.zero,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomAmountText(
                                        amount: '${wallet.balance.toStringAsFixed(2)}',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
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
                            );
                          } else if (state is WalletError) {
                           return SizedBox.shrink();
                          }
                          return const SizedBox();
                        },
                      ),
                      10.height,

                      /// Payment Type
                      CustomContainer(
                        margin: EdgeInsets.zero,
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
                                    Text('Full Payment', style: textStyle12(context)),
                                    CustomAmountText(
                                      amount: fullAmount.toStringAsFixed(2),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
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
                                    Text('Partial Payment', style: textStyle12(context)),
                                    CustomAmountText(
                                      amount: halfAmount.toStringAsFixed(2),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: CustomColor.appColor,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                       SizedBox(height: dimensions.screenHeight*0.1),

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
                            width: dimensions.screenHeight*0.15,
                            child: StatefulBuilder(
                              builder: (context, innerSetState) {
                                return CustomButton(
                                    isLoading: _isLoading,
                                    label: 'Pay Now',
                                    onPressed: () async {
                                      setState(() => _isLoading = true);

                                      final result = await initiateCheckoutServicePayment(
                                        context: context,
                                        orderId: 'checkout_$formattedOrderId',
                                        checkoutId: lead.id.toString(),
                                        amount: double.parse(payableAmount.value.toStringAsFixed(2)),
                                        customerId: lead.serviceCustomer!.id.toString(),
                                        name: 'Akshay',
                                        phone: '8989207770',
                                        email: 'akshay@gmail.com',
                                      );

                                      setState(() => _isLoading = false);

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
  final BookingData lead;
  const RemainingPaymentButton({super.key, required this.lead});

  @override
  State<RemainingPaymentButton> createState() => _RemainingPaymentButtonState();
}

class _RemainingPaymentButtonState extends State<RemainingPaymentButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final userSession = Provider.of<UserSession>(context);

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
      onTap: _isLoading ? null : () async {
        setState(() {_isLoading = true;});

        final result = await initiateCheckoutServicePayment(
          context: context,
          orderId: 'checkout_$formattedOrderId',
          checkoutId: widget.lead.id.toString(),
          amount: widget.lead.remainingAmount,
          customerId: widget.lead.serviceCustomer!.id.toString(),
          name: 'Akshay',
          phone: '8989207770',
          email: 'akshay@gmail.com',
        );

        setState(() {
          _isLoading = false;
        });

        if (result == true) {
          context.read<LeadBloc>().add(FetchLeadsByUser(userSession.userId!));
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

Widget _buildBookingSummary(BuildContext context, BookingData lead) {

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
        _buildRow(
          context,
          title: 'Coupon Discount (${lead.couponDiscount})',
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
          amount: '₹ ${lead.totalAmount?.toStringAsFixed(2)}',
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

Widget _buildCommissionCard(BuildContext context, { required BookingData lead}){

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