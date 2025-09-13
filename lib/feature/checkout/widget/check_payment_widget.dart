
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
import '../../lead/bloc/lead/lead_bloc.dart';
import '../../lead/bloc/lead/lead_event.dart';
import '../bloc/checkout/checkout_bloc.dart';
import '../bloc/checkout/checkout_event.dart';
import '../bloc/checkout/checkout_state.dart';
import '../model/checkout_model.dart';
import '../repository/checkout_cashfree_repository.dart';
import '../repository/checkout_repository.dart';
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

    return BlocProvider(
      create: (_) => CheckoutBloc(repository: CheckOutRepository()),

      child: BlocListener<CheckoutBloc, CheckoutState>(
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
                  widget.onPaymentDone(bookingId, createdAt, payableAmount.toStringAsFixed(2));
                },
              );
            }
            else {
              widget.onPaymentDone(bookingId, createdAt, payableAmount.toStringAsFixed(2));
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
                              paidAmount: 0,
                              // paidAmount: payableAmount,
                              orderStatus: 'processing',
                              remainingAmount: selectedPayment == PaymentMethod.afterConsultation ? serviceAmount.toDouble() : (serviceAmount - payableAmount - walletAppliedAmount).clamp(0, double.infinity).toDouble(),
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
