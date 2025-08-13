import 'package:dio/dio.dart';
import 'package:fetchtrue/core/widgets/custom_snackbar.dart';
import 'package:fetchtrue/feature/checkout/widget/wallet_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_amount_text.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_container.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../../package/repository/package_buy_repository.dart';
import '../../profile/bloc/user_bloc/user_bloc.dart';
import '../../profile/bloc/user_bloc/user_state.dart';
import '../model/checkout_model.dart';
import '../repository/cashfree_service.dart';
import '../repository/checkout_service.dart';
import '../repository/service_buy_repository.dart';
import '../screen/checkout_payment_screen.dart';


class CheckPaymentWidget extends StatefulWidget {
  // final VoidCallback onPaymentDone;
  final void Function(String bookingId, String dateTime, String amount) onPaymentDone;
  final CheckOutModel checkoutData;

  const CheckPaymentWidget({
    super.key,
    required this.onPaymentDone,
    required this.checkoutData,
  });

  @override
  State<CheckPaymentWidget> createState() => _CheckPaymentWidgetState();
}

enum PaymentMethod { cashFree, afterConsultation }
enum CashFreeOption { full, partial }

class _CheckPaymentWidgetState extends State<CheckPaymentWidget> {
  PaymentMethod? selectedPayment;
  CashFreeOption selectedCashFreeOption = CashFreeOption.full;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final dimensions = Dimensions(context);
    final int serviceAmount = widget.checkoutData.totalAmount ?? 0;
    final int partialAmount = (serviceAmount / 2).round();

    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {

        if(state is UserLoading){
          return CircularProgressIndicator();
        }

        if (state is UserLoaded) {
         final  user = state.user;
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                10.height,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: 'Service amount: ', style: textStyle14(context)),
                          TextSpan(text: '₹ $serviceAmount', style: textStyle14(context)),
                        ],
                      ),
                    ),
                    10.height,
                    WalletCardWidget(),
                    30.height,
                    Text(
                      'Choose Payment Method',
                      style: textStyle14(context, color: CustomColor.descriptionColor),
                    ),
                    10.height,

                    /// CashFree Pay
                    CustomContainer(
                      color: CustomColor.whiteColor,
                      margin: EdgeInsets.zero,
                      child: Row(
                        children: [
                          Radio<PaymentMethod>(
                            value: PaymentMethod.cashFree,
                            groupValue: selectedPayment,
                            activeColor: CustomColor.appColor,
                            onChanged: (value) {
                              setState(() => selectedPayment = value);
                            },
                          ),
                          Text('CashFree Pay', style: textStyle14(context)),
                        ],
                      ),
                    ),
                    15.height,

                    if (selectedPayment == PaymentMethod.cashFree)
                      CustomContainer(
                        color: CustomColor.whiteColor,
                        margin: const EdgeInsets.only(bottom: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                Radio<CashFreeOption>(
                                  value: CashFreeOption.full,
                                  groupValue: selectedCashFreeOption,
                                  activeColor: CustomColor.appColor,
                                  onChanged: (value) {
                                    setState(() => selectedCashFreeOption = value!);
                                  },
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Full Payment', style: textStyle12(context)),
                                    CustomAmountText(amount: '$serviceAmount'),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Radio<CashFreeOption>(
                                  value: CashFreeOption.partial,
                                  groupValue: selectedCashFreeOption,
                                  activeColor: CustomColor.appColor,
                                  onChanged: (value) {
                                    setState(() => selectedCashFreeOption = value!);
                                  },
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Partial Payment', style: textStyle12(context)),
                                    CustomAmountText(amount: '$partialAmount'),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                    /// After Consultation
                    CustomContainer(
                      color: CustomColor.whiteColor,
                      margin: EdgeInsets.zero,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.currency_rupee, size: 16),
                              10.width,
                              Text('Payment after consultation', style: textStyle14(context)),
                            ],
                          ),
                          Radio<PaymentMethod>(
                            value: PaymentMethod.afterConsultation,
                            groupValue: selectedPayment,
                            activeColor: CustomColor.appColor,
                            onChanged: (value) {
                              setState(() => selectedPayment = value);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: selectedPayment == PaymentMethod.cashFree
                    ? dimensions.screenHeight * 0.15
                    : dimensions.screenHeight * 0.25),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Total Price', style: textStyle16(context)),
                        10.width,
                        CustomAmountText(
                          amount: selectedPayment == null
                              ? '0'
                              : selectedPayment == PaymentMethod.afterConsultation
                              ? '$serviceAmount'
                              : selectedCashFreeOption == CashFreeOption.full
                              ? '$serviceAmount'
                              : '$partialAmount',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: CustomColor.greenColor,
                        ),
                      ],
                    ),



                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: CustomButton(
                          isLoading: _isLoading,
                          label: 'Pay Now',
                          onPressed: () async {
                            if (selectedPayment == null) {
                              showCustomSnackBar(context, 'Please select a payment method');
                              return;
                            }

                            setState(() => _isLoading = true);
                            String? checkoutId;
                            String? bookingId;

                            final now = DateTime.now();
                            final formattedOrderId =
                                "${now.day.toString().padLeft(2, '0')}"
                                "${now.month.toString().padLeft(2, '0')}"
                                "${now.year.toString().substring(2)}"
                                "${now.hour.toString().padLeft(2, '0')}"
                                "${now.minute.toString().padLeft(2, '0')}"
                                "${now.second.toString().padLeft(2, '0')}";

                            try {
                              final isPartial = selectedCashFreeOption == CashFreeOption.partial;
                              final isCashFree = selectedPayment == PaymentMethod.cashFree;
                              final isPac = selectedPayment == PaymentMethod.afterConsultation;

                              final paidAmount = isPac ? 0 : isPartial ? partialAmount : serviceAmount;
                              final remainingAmount = isPac
                                  ? serviceAmount
                                  : isPartial
                                  ? serviceAmount - partialAmount
                                  : 0;

                              final updatedCheckout = widget.checkoutData.copyWith(
                                paymentMethod: [isCashFree ? 'cashfree' : 'pac'],
                                walletAmount: 0,
                                otherAmount: 0,
                                paidAmount: 0,
                                // paidAmount: paidAmount,
                                remainingAmount: remainingAmount,
                                paymentStatus: isPac ? 'unpaid' : 'pending',
                                orderStatus: 'processing',
                                isPartialPayment: isCashFree ? isPartial : false,
                              );

                              if (isPac) {

                                final checkoutResult = await CheckOutService.checkOutService(updatedCheckout);
                                if (!mounted) return;
                                if (checkoutResult != null) {
                                  bookingId = checkoutResult.bookingId;
                                  showCustomSnackBar(context, '✅ Booking confirmed.\nBooking ID: $bookingId');
                                  // widget.onPaymentDone();
                                  if (bookingId != null && mounted) {
                                    print('CheckoutData before API call: ${checkoutResult.paidAmount}');
                                    widget.onPaymentDone(bookingId, checkoutResult.createdAt.toString(), checkoutResult.paidAmount.toString());
                                  }

                                } else {
                                  showCustomSnackBar(context, '❌ Something went wrong.');
                                }
                              }

                              else {

                                final checkoutResult = await CheckOutService.checkOutService(updatedCheckout);
                                if (!mounted) return;
                                if (checkoutResult != null) {

                                  bookingId = checkoutResult.bookingId;
                                  checkoutId = checkoutResult.id;

                                  initiateServicePayment(
                                    context: context,
                                    orderId: 'checkout_$formattedOrderId',
                                    checkoutId: checkoutId!,
                                    amount: paidAmount,
                                    customerId: user.id,
                                    name: user.fullName,
                                    phone: user.mobileNumber,
                                    email: user.email,
                                    onPaymentSuccess: () {
                                      widget.onPaymentDone(bookingId!, checkoutResult.createdAt.toString(),serviceAmount.toString());
                                    },
                                  );

                                }
                                else {
                                  showCustomSnackBar(context, '❌ Something went wrong.');
                                }
                              }
                            } catch (e) {
                              if (e is DioException && e.response?.data != null) {
                                final data = e.response!.data;
                                final match = RegExp(r'bookingId[":\s]+([a-zA-Z0-9]+)').firstMatch(data.toString());
                                if (match != null) bookingId = match.group(1);
                              }

                              if (mounted) {
                                final errorMsg = bookingId != null
                                    ? '❌ Error for Booking ID: $bookingId'
                                    : '❌ Payment error: ${e.toString()}';
                                showCustomSnackBar(context, errorMsg);
                              }
                            } finally {
                              if (mounted) setState(() => _isLoading = false);
                            }
                          }
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        if(state is UserError){
          return Text(state.message);
        }

        return SizedBox.shrink();
      },
    );
  }
}
