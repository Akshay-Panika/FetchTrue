import 'package:fetchtrue/core/widgets/custom_snackbar.dart';
import 'package:fetchtrue/feature/checkout/widget/wallet_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_amount_text.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_container.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../../service/model/service_model.dart';
import '../model/checkout_model.dart';
import '../repository/cashfree_service.dart';
import '../repository/checkout_service.dart';

class CheckPaymentWidget extends StatefulWidget {
  final List<ServiceModel> services;
  final VoidCallback onPaymentDone;
  final CheckOutModel checkoutData;
  final String providerId;

  const CheckPaymentWidget({
    super.key,
    required this.services,
    required this.onPaymentDone,
    required this.checkoutData,
    required this.providerId,
  });

  @override
  State<CheckPaymentWidget> createState() => _CheckPaymentWidgetState();
}

enum PaymentMethod { cashFree, afterConsultation }
enum CashFreeOption { full, partial }

class _CheckPaymentWidgetState extends State<CheckPaymentWidget> {
  PaymentMethod? selectedPayment;
  CashFreeOption selectedCashFreeOption = CashFreeOption.full;

  late int serviceAmount;
  late int partialAmount;
  bool _isLoading = false;


  @override
  void initState() {
    super.initState();
    /// Safe sum of all discounted prices
    serviceAmount = widget.services.fold(0, (total, service) {
      final price = int.tryParse(widget.services.first.discountedPrice.toString() ?? '0') ?? 0;
      return total + price;
    });

    partialAmount = (serviceAmount / 2).round();
  }



  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    final userSession = Provider.of<UserSession>(context);

    return Padding(
      padding:  EdgeInsets.all(15.0),
      child: Column(
        children: [
          /// Payment Selection Title
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(text: TextSpan(
                children: [
                 TextSpan(text: 'Service amount: ', style: textStyle14(context)),
                 TextSpan(text: '₹ ${widget.services.first.discountedPrice}',style: textStyle14(context)),
                ]
              )),
              10.height,

              /// Wallet
              WalletCardWidget(),
              30.height,

              /// Pay via Online
              Text(
                'Choose Payment Method',
                style: textStyle14(context, color: CustomColor.descriptionColor),
              ),
              10.height,

              /// CashFree Pay Option
              CustomContainer(
                backgroundColor: CustomColor.whiteColor,
                margin: EdgeInsets.zero,
                child: Row(
                  children: [
                    Radio<PaymentMethod>(
                      value: PaymentMethod.cashFree,
                      groupValue: selectedPayment,
                      activeColor: CustomColor.appColor,
                      onChanged: (value) {
                        setState(() {
                          selectedPayment = value;
                        });
                      },
                    ),
                    Text('CashFree Pay', style: textStyle14(context)),
                  ],
                ),
              ),
              15.height,

              /// Show full/partial options if CashFree is selected
              if (selectedPayment == PaymentMethod.cashFree)
                CustomContainer(
                  backgroundColor: CustomColor.whiteColor,
                  margin: const EdgeInsets.only(bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      /// Full Payment
                      Row(
                        children: [
                          Radio<CashFreeOption>(
                            value: CashFreeOption.full,
                            groupValue: selectedCashFreeOption,
                            activeColor: CustomColor.appColor,
                            onChanged: (value) {
                              setState(() {
                                selectedCashFreeOption = value!;
                              });
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

                      /// Partial Payment
                      Row(
                        children: [
                          Radio<CashFreeOption>(
                            value: CashFreeOption.partial,
                            groupValue: selectedCashFreeOption,
                            activeColor: CustomColor.appColor,
                            onChanged: (value) {
                              setState(() {
                                selectedCashFreeOption = value!;
                              });
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

              /// Pay After Consultation
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
                      value: PaymentMethod.afterConsultation,
                      groupValue: selectedPayment,
                      activeColor: CustomColor.appColor,
                      onChanged: (value) {
                        setState(() {
                          selectedPayment = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),


          SizedBox(height:
          selectedPayment == PaymentMethod.cashFree ?
          dimensions.screenHeight * 0.15:dimensions.screenHeight * 0.25),

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
                    amount: selectedPayment == null ? '0' : selectedPayment == PaymentMethod.afterConsultation
                        ? '$serviceAmount' : selectedCashFreeOption == CashFreeOption.full
                        ? '$serviceAmount' : '$partialAmount',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: CustomColor.greenColor,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: CustomButton(
                  isLoading: false,
                  label: 'Pay Now',
                    onPressed: () async {
                      final isPartial = selectedCashFreeOption == CashFreeOption.partial;
                      final payableAmount = selectedPayment == PaymentMethod.afterConsultation ? 0 : isPartial ? partialAmount : serviceAmount;

                      final updatedCheckout = widget.checkoutData.copyWith(
                        paymentMethod: ['pac'],
                        walletAmount: 0,
                        paymentStatus: 'pending',
                        orderStatus: 'processing',
                        totalAmount: serviceAmount,
                      );

                      if (selectedPayment == null) {
                        showCustomSnackBar(context, 'Please select a payment method');
                        return;
                      }

                      else {
                        if(selectedPayment == PaymentMethod.afterConsultation){
                          final isSuccess = await CheckOutService.checkOutService(updatedCheckout);
                          // showCustomSnackBar(context, 'Successfully!');
                          widget.onPaymentDone();
                        }

                        else{
                          if (selectedPayment == PaymentMethod.cashFree) {
                            await cashFreeService( context,
                              amount: payableAmount,
                              customerId: '',
                              name: "Customer Name",
                              email: "customer@example.com",
                              phone: '8989207770',
                            );
                          }
                        }
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



