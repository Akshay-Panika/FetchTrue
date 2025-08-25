// import 'package:dio/dio.dart';
// import 'package:fetchtrue/core/widgets/custom_snackbar.dart';
// import 'package:fetchtrue/feature/checkout/repository/checkout_repository.dart';
// import 'package:fetchtrue/feature/checkout/widget/wallet_card_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../core/costants/custom_color.dart';
// import '../../../core/costants/dimension.dart';
// import '../../../core/costants/text_style.dart';
// import '../../../core/widgets/custom_amount_text.dart';
// import '../../../core/widgets/custom_button.dart';
// import '../../../core/widgets/custom_container.dart';
// import '../../auth/user_notifier/user_notifier.dart';
// import '../model/checkout_model.dart';
// import '../repository/checkout_service.dart';
// import '../repository/checkout_cashfree_repository.dart';
//
// class CheckPaymentWidget extends StatefulWidget {
//   final void Function(String bookingId, String dateTime, String amount) onPaymentDone;
//   final CheckOutModel checkoutData;
//
//   const CheckPaymentWidget({
//     super.key,
//     required this.onPaymentDone,
//     required this.checkoutData,
//   });
//
//   @override
//   State<CheckPaymentWidget> createState() => _CheckPaymentWidgetState();
// }
//
// enum PaymentMethod { cashFree, afterConsultation }
// enum CashFreeOption { full, partial }
//
// class _CheckPaymentWidgetState extends State<CheckPaymentWidget> {
//   PaymentMethod? selectedPayment;
//   CashFreeOption selectedCashFreeOption = CashFreeOption.full;
//
//   bool _isLoading = false;
//   double walletAppliedAmount = 0;
//   final CheckOutRepository repository = CheckOutRepository();
//
//
//   @override
//   Widget build(BuildContext context) {
//     final userSession = Provider.of<UserSession>(context);
//     final dimensions = Dimensions(context);
//
//     final num serviceAmount = widget.checkoutData.totalAmount ?? 0.0;
//     final double partialAmount = double.parse((serviceAmount / 2).toStringAsFixed(2));
//
//     final double payableAmount = (
//         (selectedPayment == null
//             ? 0
//             : selectedPayment == PaymentMethod.afterConsultation
//             ? serviceAmount
//             : selectedCashFreeOption == CashFreeOption.full
//             ? serviceAmount
//             : partialAmount
//         ) - walletAppliedAmount
//     ).clamp(0, double.infinity);
//
//     return Padding(
//       padding: const EdgeInsets.all(15.0),
//       child: Column(
//         children: [
//           10.height,
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               RichText(
//                 text: TextSpan(
//                   children: [
//                     TextSpan(text: 'Service amount: ', style: textStyle14(context)),
//                     TextSpan(text: '₹ ${serviceAmount.toStringAsFixed(2)}', style: textStyle14(context)),
//                   ],
//                 ),
//               ),
//               10.height,
//               WalletCardWidget(
//                 userId: userSession.userId!,
//                 onWalletApplied: (walletBalance) {
//                   setState(() {
//                     walletAppliedAmount = walletBalance >= serviceAmount
//                         ? serviceAmount.toDouble()
//                         : walletBalance.toDouble();
//                   });
//                 },
//               ),
//
//               30.height,
//               Text(
//                 'Choose Payment Method',
//                 style: textStyle14(context, color: CustomColor.descriptionColor),
//               ),
//               10.height,
//
//               /// CashFree Pay
//               CustomContainer(
//                 color: CustomColor.whiteColor,
//                 margin: EdgeInsets.zero,
//                 child: Row(
//                   children: [
//                     Radio<PaymentMethod>(
//                       value: PaymentMethod.cashFree,
//                       groupValue: selectedPayment,
//                       activeColor: CustomColor.appColor,
//                       onChanged: (value) {
//                         setState(() => selectedPayment = value);
//                       },
//                     ),
//                     Text('CashFree Pay', style: textStyle14(context)),
//                   ],
//                 ),
//               ),
//               15.height,
//
//               if (selectedPayment == PaymentMethod.cashFree)
//                 CustomContainer(
//                   color: CustomColor.whiteColor,
//                   margin: const EdgeInsets.only(bottom: 15),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       Row(
//                         children: [
//                           Radio<CashFreeOption>(
//                             value: CashFreeOption.full,
//                             groupValue: selectedCashFreeOption,
//                             activeColor: CustomColor.appColor,
//                             onChanged: (value) {
//                               setState(() => selectedCashFreeOption = value!);
//                             },
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text('Full Payment', style: textStyle12(context)),
//                               CustomAmountText(amount: '${serviceAmount.toStringAsFixed(2)}'),
//                             ],
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           Radio<CashFreeOption>(
//                             value: CashFreeOption.partial,
//                             groupValue: selectedCashFreeOption,
//                             activeColor: CustomColor.appColor,
//                             onChanged: (value) {
//                               setState(() => selectedCashFreeOption = value!);
//                             },
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text('Partial Payment', style: textStyle12(context)),
//                               CustomAmountText(amount: '${partialAmount.toStringAsFixed(2)}'),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//
//               /// After Consultation
//               CustomContainer(
//                 color: CustomColor.whiteColor,
//                 margin: EdgeInsets.zero,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         Icon(Icons.currency_rupee, size: 16),
//                         10.width,
//                         Text('Payment after consultation', style: textStyle14(context)),
//                       ],
//                     ),
//                     Radio<PaymentMethod>(
//                       value: PaymentMethod.afterConsultation,
//                       groupValue: selectedPayment,
//                       activeColor: CustomColor.appColor,
//                       onChanged: (value) {
//                         setState(() => selectedPayment = value);
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//
//           SizedBox(height: selectedPayment == PaymentMethod.cashFree
//               ? dimensions.screenHeight * 0.15
//               : dimensions.screenHeight * 0.25),
//
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text('Total Price', style: textStyle16(context)),
//                   10.width,
//                   CustomAmountText(
//                     amount: payableAmount.toStringAsFixed(2),
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                     color: CustomColor.greenColor,
//                   ),
//                 ],
//               ),
//
//               Padding(
//                 padding: const EdgeInsets.all(15),
//                 child: CustomButton(
//                   isLoading: _isLoading,
//                   label: 'Pay Now',
//                   onPressed: () async {
//                     if (selectedPayment == null) {
//                       showCustomSnackBar(context, 'Please select a payment method');
//                       return;
//                     }
//
//                     setState(() => _isLoading = true);
//                     String? bookingId;
//
//                     final now = DateTime.now();
//                     final formattedOrderId =
//                         "${now.day.toString().padLeft(2, '0')}"
//                         "${now.month.toString().padLeft(2, '0')}"
//                         "${now.year.toString().substring(2)}"
//                         "${now.hour.toString().padLeft(2, '0')}"
//                         "${now.minute.toString().padLeft(2, '0')}"
//                         "${now.second.toString().padLeft(2, '0')}";
//
//                     try {
//                       final isPartial = selectedCashFreeOption == CashFreeOption.partial;
//                       final isCashFree = selectedPayment == PaymentMethod.cashFree;
//                       final isPac = selectedPayment == PaymentMethod.afterConsultation;
//
//                       final num paidAmountNum = isPac ? 0 : isPartial ? partialAmount : serviceAmount;
//                       final double finalAmount = double.parse(paidAmountNum.toStringAsFixed(2));
//
//                       final double remainingAmount = isPac
//                           ? double.parse(serviceAmount.toStringAsFixed(2))
//                           : isPartial
//                           ? double.parse((serviceAmount - partialAmount).toStringAsFixed(2))
//                           : 0.0;
//
//                       final List<String> paymentMethods = [];
//                       if (isCashFree) paymentMethods.add("cashfree");
//                       if (isPac) paymentMethods.add("pac");
//                       if (walletAppliedAmount > 0) paymentMethods.add("wallet");
//
//                       final updatedCheckout = widget.checkoutData.copyWith(
//                         paymentMethod: paymentMethods,
//                         walletAmount: walletAppliedAmount,
//                         otherAmount: 0,
//                         paidAmount: payableAmount,
//                         grandTotal: serviceAmount,
//                         remainingAmount: remainingAmount,
//                         paymentStatus: isPac ? 'unpaid' : 'pending',
//                         orderStatus: 'processing',
//                         isPartialPayment: isCashFree ? isPartial : false,
//                       );
//
//                       // अगर पूरा amount wallet से cover हुआ → direct booking confirm
//                       if (walletAppliedAmount >= serviceAmount) {
//                         final checkoutResult = await CheckOutService.checkOutService(updatedCheckout);
//                         if (!mounted) return;
//                         if (checkoutResult != null) {
//                           bookingId = checkoutResult.bookingId;
//                           showCustomSnackBar(context, '✅ Booking confirmed.\nBooking ID: $bookingId');
//                           if (bookingId != null && mounted) {
//                             widget.onPaymentDone(
//                                 bookingId,
//                                 checkoutResult.createdAt.toString(),
//                                 checkoutResult.paidAmount?.toStringAsFixed(2) ?? "0.00"
//                             );
//                           }
//                         }
//                       } else if (isPac) {
//                         final checkoutResult = await repository.checkout(updatedCheckout);
//                         if (!mounted) return;
//                         if (checkoutResult != null) {
//                           bookingId = checkoutResult.bookingId;
//                           showCustomSnackBar(context, '✅ Booking confirmed.\nBooking ID: $bookingId');
//                           if (bookingId != null && mounted) {
//                             widget.onPaymentDone(
//                                 bookingId,
//                                 checkoutResult.createdAt.toString(),
//                                 checkoutResult.paidAmount?.toStringAsFixed(2) ?? "0.00"
//                             );
//                           }
//                         }
//                       } else {
//                         // CashFree + remaining amount
//                         final checkoutResult = await repository.checkout(updatedCheckout);
//                         if (!mounted) return;
//                         if (checkoutResult != null) {
//                           bookingId = checkoutResult.bookingId;
//                           final checkoutId = checkoutResult.id;
//
//                           initiateServicePayment(
//                             context: context,
//                             orderId: 'checkout_$formattedOrderId',
//                             checkoutId: checkoutId!,
//                             amount: payableAmount,
//                             customerId: userSession.userId!,
//                             name: 'Customer',
//                             phone: '9999999999',
//                             email: 'customer@mail.com',
//                             onPaymentSuccess: () {
//                               widget.onPaymentDone(
//                                 bookingId!,
//                                 checkoutResult.createdAt.toString(),
//                                 payableAmount.toStringAsFixed(2),
//                               );
//                             },
//                           );
//                         } else {
//                           showCustomSnackBar(context, '❌ Something went wrong.');
//                         }
//                       }
//                     } catch (e) {
//                       if (e is DioException && e.response?.data != null) {
//                         final data = e.response!.data;
//                         final match = RegExp(r'bookingId[":\s]+([a-zA-Z0-9]+)').firstMatch(data.toString());
//                         if (match != null) bookingId = match.group(1);
//                       }
//
//                       if (mounted) {
//                         final errorMsg = bookingId != null
//                             ? '❌ Error for Booking ID: $bookingId'
//                             : '❌ Payment error: ${e.toString()}';
//                         showCustomSnackBar(context, errorMsg);
//                       }
//                     } finally {
//                       if (mounted) setState(() => _isLoading = false);
//                     }
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_amount_text.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../../my_lead/bloc/lead/lead_bloc.dart';
import '../../my_lead/bloc/lead/lead_event.dart';
import '../bloc/checkout/checkout_bloc.dart';
import '../bloc/checkout/checkout_event.dart';
import '../bloc/checkout/checkout_state.dart';
import '../model/checkout_model.dart';
import '../repository/checkout_cashfree_repository.dart';
import '../widget/wallet_card_widget.dart';


class CheckPaymentWidget extends StatefulWidget {
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
  double walletAppliedAmount = 0;

  @override
  Widget build(BuildContext context) {
    final userSession = Provider.of<UserSession>(context);
    final num serviceAmount = widget.checkoutData.totalAmount ?? 0.0;
    final double partialAmount = double.parse((serviceAmount / 2).toStringAsFixed(2));

    final double payableAmount = (
        (selectedPayment == null ? 0 : selectedPayment == PaymentMethod.afterConsultation ? serviceAmount
            : selectedCashFreeOption == CashFreeOption.full ? serviceAmount : partialAmount) - walletAppliedAmount).clamp(0, double.infinity);

    return BlocListener<CheckoutBloc, CheckoutState>(
      listener: (context, state) {
        if (state is CheckoutSuccess) {
          final bookingId = state.model.bookingId ?? '';
          final checkoutId = state.model.id ?? '';
          final createdAt = state.model.createdAt?.toString() ?? '';
          final paidAmount = state.model.paidAmount?.toStringAsFixed(2) ?? "0.00";

          print('Booking confirmed. ID: $bookingId');

          if (selectedPayment == PaymentMethod.cashFree) {
            checkoutCashfreeRepository(
              context: context,
              orderId: 'checkout_$bookingId',
              checkoutId: checkoutId,
              amount: payableAmount,
              customerId: userSession.userId!,
              name: 'Customer',
              phone: '9999999999',
              email: 'customer@mail.com',
              onPaymentSuccess: () {
                widget.onPaymentDone(bookingId, createdAt, paidAmount);
              },
            );
          }
          else {
            widget.onPaymentDone(bookingId, createdAt, paidAmount);
          }

          context.read<LeadBloc>().add(FetchLeadsByUser(userSession.userId!));
        } else if (state is CheckoutFailure) {
          showCustomToast('❌ ${state.error}');
        }
      },
      child: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 15),
                children: [
                  15.height,
                  /// wallet
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Price: ₹ ${serviceAmount.toStringAsFixed(2)}', style: textStyle16(context)),
                      10.height,
                      WalletCardWidget(
                        userId: userSession.userId!,
                        onWalletApplied: (walletBalance) {
                          setState(() {
                            walletAppliedAmount = walletBalance >= serviceAmount ? serviceAmount.toDouble() : walletBalance.toDouble();
                          });
                        },
                      ),
                    ],
                  ),

                  20.height,

                  /// Payment Options
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Choose Payment Method', style: textStyle14(context, color: CustomColor.descriptionColor)),
                      10.height,
                      _paymentOptionWidgets(serviceAmount, partialAmount),
                    ],
                  ),
                ],
              ),
            ),

            /// Total + Pay Button
            Padding(
              padding: const EdgeInsets.all(50),
              child: Column(
                spacing: 20,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Total Price', style: textStyle16(context)),10.width,
                      Text('₹ ${payableAmount.toStringAsFixed(2)}', style: textStyle16(context)),
                    ],
                  ),
                  BlocBuilder<CheckoutBloc, CheckoutState>(
                    builder: (context, state) {
                      final isLoading = state is CheckoutLoading;
                      return CustomButton(
                        isLoading: isLoading,
                        label: 'Pay Now',
                        onPressed: () {
                          if (selectedPayment == null) {
                            showCustomToast('Please select a payment method');
                            return;
                          }

                          /// prepare model
                          final checkoutModel = widget.checkoutData.copyWith(
                            paymentMethod: [
                              if (selectedPayment == PaymentMethod.cashFree) 'cashfree',
                              if (selectedPayment == PaymentMethod.afterConsultation) 'pac',
                              if (walletAppliedAmount > 0) 'wallet',
                            ],
                            walletAmount: walletAppliedAmount,
                            paidAmount: payableAmount,
                            orderStatus: 'processing',
                            remainingAmount: selectedPayment == PaymentMethod.afterConsultation
                                ? serviceAmount.toDouble()
                                : (serviceAmount - payableAmount - walletAppliedAmount)
                                .clamp(0, double.infinity)
                                .toDouble(),
                            paymentStatus: selectedPayment == PaymentMethod.afterConsultation ? 'unpaid' : 'pending',
                            isPartialPayment: selectedPayment == PaymentMethod.cashFree ? selectedCashFreeOption == CashFreeOption.partial : false,
                          );

                          context.read<CheckoutBloc>().add(CheckoutRequestEvent(checkoutModel));
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _paymentOptionWidgets(num serviceAmount, double partialAmount) {
    return Column(
      children: [
        /// CashFree
        CustomContainer(
          color: CustomColor.whiteColor,
          margin: EdgeInsets.zero,
          child: Column(
            children: [
              Row(
                children: [
                  Radio<PaymentMethod>(
                    value: PaymentMethod.cashFree,
                    groupValue: selectedPayment,
                    activeColor: CustomColor.appColor,
                    onChanged: (value) => setState(() => selectedPayment = value),
                  ),
                  Text('CashFree Pay', style: textStyle14(context)),
                ],
              ),

              if (selectedPayment == PaymentMethod.cashFree)
                Column(
                  children: [
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _cashFreeOption("Full Payment", serviceAmount.toDouble(), CashFreeOption.full),
                        _cashFreeOption("Partial Payment", partialAmount, CashFreeOption.partial),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ),

        30.height,

        /// After Consultation
        CustomContainer(
          color: CustomColor.whiteColor,
          margin: EdgeInsets.zero,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Payment after consultation', style: textStyle14(context)),
              Radio<PaymentMethod>(
                value: PaymentMethod.afterConsultation,
                groupValue: selectedPayment,
                activeColor: CustomColor.appColor,
                onChanged: (value) => setState(() => selectedPayment = value),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _cashFreeOption(String label, double amount, CashFreeOption option) {
    return Row(
      children: [
        Radio<CashFreeOption>(
          value: option,
          groupValue: selectedCashFreeOption,
          activeColor: CustomColor.appColor,
          onChanged: (value) => setState(() => selectedCashFreeOption = value!),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: textStyle12(context)),
            CustomAmountText(amount: '${amount.toStringAsFixed(2)}'),
          ],
        ),
      ],
    );
  }
}
