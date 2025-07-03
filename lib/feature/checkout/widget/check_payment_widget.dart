import 'package:fetchtrue/core/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_amount_text.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_container.dart';
import '../../service/model/service_model.dart';
import '../model/check_out_model.dart';
import '../repository/check_out_service.dart';

enum PaymentMethod { payAfterService, cashfree }
enum CashfreeSubOption { full, partial }

class CheckPaymentWidget extends StatefulWidget {
  final List<ServiceModel> services;
  final VoidCallback onPaymentDone;
  final CheckoutModel checkoutData;
  final String providerId;

  const CheckPaymentWidget({
    super.key,
    required this.services,
    required this.onPaymentDone, required this.checkoutData, required this.providerId,
  });

  @override
  State<CheckPaymentWidget> createState() => _CheckPaymentWidgetState();
}

class _CheckPaymentWidgetState extends State<CheckPaymentWidget> {
  bool isWalletApplied = false;
  PaymentMethod? selectedMethod;
  CashfreeSubOption selectedCashfreeOption = CashfreeSubOption.full;

  bool _isLoading = false;
  double get totalAmount {
    if (selectedMethod == PaymentMethod.cashfree) {
      if (selectedCashfreeOption == CashfreeSubOption.partial) {
        return 250.00;
      } else {
        return 500.00;
      }
    }
    return 500.00;
  }

  @override
  Widget build(BuildContext context) {

    Dimensions dimensions = Dimensions(context);

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          /// Payment Selection
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Choose Payment Method ${widget.providerId}',
                style: textStyle14(context, color: CustomColor.descriptionColor),
              ),
              10.height,

              /// Wallet
              CustomContainer(
                backgroundColor: CustomColor.whiteColor,
                margin: EdgeInsets.zero,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        CustomAmountText(
                          amount: '00.00',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: CustomColor.appColor,
                        ),
                        Text(
                          'Wallet Balance',
                          style: textStyle14(
                            context,
                            color: CustomColor.descriptionColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isWalletApplied = !isWalletApplied;
                        });
                      },
                      child: Text(
                        isWalletApplied ? 'Remove' : 'Apply',
                        style: textStyle16(
                          context,
                          color: isWalletApplied
                              ? CustomColor.redColor
                              : CustomColor.greenColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              15.height,

              Text(
                'Pay Via Online',
                style: textStyle14(context, color: CustomColor.descriptionColor),
              ),
              10.height,
              /// CashFree Option
              CustomContainer(
                backgroundColor: CustomColor.whiteColor,
                margin: EdgeInsets.zero,
                child: Row(
                  children: [
                    Radio<PaymentMethod>(
                      value: PaymentMethod.cashfree,
                      groupValue: selectedMethod,
                      activeColor: CustomColor.appColor,
                      onChanged: (value) {
                        setState(() {
                          selectedMethod = value;
                        });
                      },
                    ),
                    Text('CashFree Pay', style: textStyle14(context)),
                  ],
                ),
              ),
              15.height,

              /// Show only if CashFree selected
              if (selectedMethod == PaymentMethod.cashfree)
                CustomContainer(
                  backgroundColor: CustomColor.whiteColor,
                  margin: EdgeInsets.only(bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Radio<CashfreeSubOption>(
                            value: CashfreeSubOption.full,
                            groupValue: selectedCashfreeOption,
                            activeColor: CustomColor.appColor,
                            onChanged: (value) {
                              setState(() {
                                selectedCashfreeOption = value!;
                              });
                            },
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Full Payment', style: textStyle12(context)),
                              CustomAmountText(amount: '500.00'),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Radio<CashfreeSubOption>(
                            value: CashfreeSubOption.partial,
                            groupValue: selectedCashfreeOption,
                            activeColor: CustomColor.appColor,
                            onChanged: (value) {
                              setState(() {
                                selectedCashfreeOption = value!;
                              });
                            },
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Partial Payment', style: textStyle12(context)),
                              CustomAmountText(amount: '250.00'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),


              /// Pay After Service
              CustomContainer(
                backgroundColor: CustomColor.whiteColor,
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
                      value: PaymentMethod.payAfterService,
                      groupValue: selectedMethod,
                      activeColor: CustomColor.appColor,
                      onChanged: (value) {
                        setState(() {
                          selectedMethod = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: dimensions.screenHeight*0.2,),

          /// Total + Pay Now Button
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Total Price', style: textStyle16(context)),
                  10.width,
                  CustomAmountText(
                    amount: totalAmount.toStringAsFixed(2),
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
                  // onPressed: () async{
                  //   if (selectedMethod == null) {
                  //    showCustomSnackBar(context, 'Please select a payment method');
                  //     return;
                  //   }
                  //
                  //   setState(() => _isLoading = true);
                  //
                  //   final updatedCheckout = widget.checkoutData.copyWith(
                  //     paymentStatus: 'paid',
                  //     orderStatus: 'completed',
                  //     notes: 'Customer paid in full',
                  //     totalAmount: totalAmount.toInt(),
                  //   );
                  //
                  //
                  //   try {
                  //
                  //     await CheckOutService.checkOutService(updatedCheckout);
                  //     showCustomSnackBar(context, 'Payment completed successfully!');
                  //     widget.onPaymentDone();
                  //   } catch (e) {
                  //     showCustomSnackBar(context, 'Error: $e');
                  //   }
                  //   // final result = await CheckOutService.checkOutService(widget.checkoutData);
                  // },
                    onPressed: () async {
                      if (selectedMethod == null) {
                        showCustomSnackBar(context, 'Please select a payment method');
                        return;
                      }

                      setState(() => _isLoading = true);

                      /// Default values
                      String paymentStatus = 'pending';
                      String orderStatus = 'processing';
                      String notes = 'Customer will pay after consultation';
                      int finalAmount = totalAmount.toInt();

                      if (selectedMethod == PaymentMethod.cashfree) {
                        paymentStatus = 'paid';
                        orderStatus = 'completed';

                        if (selectedCashfreeOption == CashfreeSubOption.full) {
                          notes = 'Customer paid in full';
                        } else {
                          notes = 'Customer paid partially';
                        }
                      }

                      final updatedCheckout = widget.checkoutData.copyWith(
                        paymentStatus: paymentStatus,
                        orderStatus: orderStatus,
                        notes: notes,
                        totalAmount: finalAmount,
                        provider:  widget.providerId
                      );

                      try {
                        final isSuccess = await CheckOutService.checkOutService(updatedCheckout);

                        if (isSuccess != null) {
                          showCustomSnackBar(context, 'Payment status updated successfully!');
                          widget.onPaymentDone();
                        } else {
                          showCustomSnackBar(context, 'Failed to update payment data.');
                        }
                      } catch (e) {
                        showCustomSnackBar(context, 'Error: $e');
                      } finally {
                        setState(() => _isLoading = false);
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
}