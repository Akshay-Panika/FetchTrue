
import 'package:fetchtrue/core/widgets/formate_price.dart';
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
import '../../coupon/bloc/coupon/coupon_state.dart';
import '../../coupon/bloc/coupon_apply/coupon_apply_bloc.dart';
import '../../coupon/bloc/coupon_apply/coupon_apply_event.dart';
import '../../coupon/bloc/coupon_apply/coupon_apply_state.dart';
import '../../coupon/model/coupon_apply_model.dart';
import '../../coupon/repository/coupon_apply_repository.dart';
import '../../lead/bloc/lead/lead_bloc.dart';
import '../../lead/bloc/lead/lead_event.dart';
import '../../profile/bloc/user/user_bloc.dart';
import '../../profile/bloc/user/user_state.dart';
import '../bloc/checkout/checkout_bloc.dart';
import '../bloc/checkout/checkout_event.dart';
import '../bloc/checkout/checkout_state.dart';
import '../bloc/payu_gateway/payu_gateway_bloc.dart';
import '../model/checkout_model.dart';
import '../model/payu_gateway_model.dart';
import '../model/payu_gateway_response_model.dart';
import '../repository/checkout_repository.dart';
import '../repository/payu_gateway_repository.dart';
import '../screen/payu_open_in_app_view_screen.dart';
import '../widget/wallet_card_widget.dart';


class CheckPaymentWidget extends StatefulWidget {
  final void Function(String bookingId, String dateTime, String amount,) onPaymentDone;
  final CheckOutModel checkoutData;
  final String zoneId;

  const CheckPaymentWidget({
    super.key,
    required this.onPaymentDone,
    required this.checkoutData, required this.zoneId,
  });

  @override
  State<CheckPaymentWidget> createState() => _CheckPaymentWidgetState();
}

enum PaymentMethod { payU, afterConsultation }
enum PayUOption { full, partial }

class _CheckPaymentWidgetState extends State<CheckPaymentWidget> {
  PaymentMethod? selectedPayment;
  PayUOption selectedPayUOption = PayUOption.full;
  double walletAppliedAmount = 0;

  String _bookingId = '';
  String _createdAt = '';
  double _payableAmount = 0;

  @override
  Widget build(BuildContext context) {
    final userSession = Provider.of<UserSession>(context);

    final num serviceAmount = (widget.checkoutData.totalAmount ?? 0).round();
    final partialAmount = (serviceAmount / 2);
    final double payableAmount = (
        (selectedPayment == null
            ? 0
            : selectedPayment == PaymentMethod.afterConsultation
            ? serviceAmount
            : selectedPayUOption == PayUOption.full
            ? serviceAmount
            : partialAmount) - walletAppliedAmount)
        .clamp(0, double.infinity);

    _payableAmount = payableAmount;

    return BlocBuilder<UserBloc, UserState>(
        builder: (context, userState) {

          if (userState is UserInitial || userState is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (userState is UserError) {
            debugPrint('Error: ${userState.massage}');
          }

          if(userState is UserLoaded){
            final user = userState.user;
            return MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => CheckoutBloc(repository: CheckOutRepository())),
                BlocProvider(create: (_) => CouponApplyBloc(CouponApplyRepository())),
                BlocProvider(create: (_) => PayUGatewayBloc(PayUGatewayRepository()))
              ],
              child: BlocListener<CheckoutBloc, CheckoutState>(
                listener: (context, state) {
                  if (state is CheckoutSuccess) {
                    _bookingId = state.model.bookingId ?? '';
                    _createdAt = state.model.createdAt?.toString() ?? '';
                    _payableAmount = state.model.paidAmount?.toDouble() ?? payableAmount;

                    print('Booking confirmed. ID: $_bookingId');

                    if (selectedPayment == PaymentMethod.afterConsultation) {
                      showCustomSnackBar(context, 'Booking done! Pay after consultation.');
                      widget.onPaymentDone(_bookingId, _createdAt, _payableAmount.toStringAsFixed(2));

                      // ✅ Lead refresh without navigation
                      context.read<LeadBloc>().add(FetchLeadsByUser(userSession.userId!));
                      return;
                    }

                    if (selectedPayment == PaymentMethod.payU) {
                      final timestamp = DateTime.now().millisecondsSinceEpoch;
                      final orderId = "checkout_$timestamp";
                      final payuModel = PayUGatewayModel(
                        subAmount: payableAmount,
                        isPartialPaymentAllowed: selectedPayUOption == PayUOption.partial,
                        description: "Service Payment",
                        orderId: orderId,
                        customer: PayUCustomer(
                          customerId: user.id,
                          customerName: user.fullName,
                          customerEmail: user.email,
                          customerPhone: user.mobileNumber,
                        ),
                        udf: PayUUdf(
                         udf1:orderId,
                          udf2: state.model.id.toString(),
                          udf3: user.id,
                        ),
                      );

                      context.read<PayUGatewayBloc>().add(CreatePayULinkEvent(payuModel));

                      // ✅ Payment initiated, refresh LeadBloc immediately
                      context.read<LeadBloc>().add(FetchLeadsByUser(userSession.userId!));
                    }
                  }

                },
                child: BlocListener<PayUGatewayBloc, PayUGatewayState>(
                  listener: (context, state) {
                    if (state is PayUGatewaySuccess) {
                      final paymentUrl = state.response.result?.paymentLink;
                      if (paymentUrl != null && paymentUrl.isNotEmpty) {
                        openInAppWebView(context,paymentUrl, () {
                          // showCustomToast('Payment Completed!');
                          widget.onPaymentDone(_bookingId, _createdAt, _payableAmount.toStringAsFixed(2));
                        });

                      }
                    } else if (state is PayUGatewayFailure) {
                      print('Payment failed: ${state.message}');
                      showCustomToast('Payment failed: ${state.message}');
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
                              Text('Price: ₹ ${formatPrice(widget.checkoutData.totalAmount??0)}', style: textStyle16(context)),

                              // WalletCardWidget(
                              //   userId: userSession.userId!,
                              //   onWalletApplied: (walletBalance) {
                              //     setState(() {
                              //       walletAppliedAmount = walletBalance >= serviceAmount ? serviceAmount.toDouble() : walletBalance.toDouble();
                              //     });
                              //   },
                              // ),
                              /// Payment Options
                              Text('Choose Payment Method', style: textStyle12(context, color: CustomColor.descriptionColor)),
                              15.height,
                              _paymentOptionWidgets(serviceAmount, partialAmount),
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
                                  Text('Total Price', style: textStyle14(context)),10.width,
                                  Text('₹ ${payableAmount.toStringAsFixed(2)}', style: textStyle14(context)),
                                ],
                              ),
                              BlocBuilder<CheckoutBloc, CheckoutState>(
                                builder: (context, state) {
                                  final isLoading = state is CheckoutLoading;
                                  return BlocConsumer<CouponApplyBloc, CouponApplyState>(
                                    listener: (context, couponState) {
                                      if (couponState is CouponApplySuccess) {
                                        print('Coupon Applied');
                                      } else if (couponState is CouponApplyFailure) {
                                        print('❌ Coupon apply failed ${couponState.error}');
                                        showCustomToast("❌ Coupon apply failed");
                                      }
                                    },
                                    builder: (context, state) {
                                      final isCouponLoading = state is CouponApplyLoading;
                                      return CustomButton(
                                        isLoading: isLoading || isCouponLoading,
                                        label: 'Book Now',
                                        onPressed: () async{

                                          if (selectedPayment == null) {
                                            showCustomToast('Please select a payment method');
                                            return;
                                          }

                                          /// prepare model
                                          final checkoutModel = widget.checkoutData.copyWith(
                                            // paymentMethod:['pac'],
                                            paymentMethod: [
                                              if (selectedPayment == PaymentMethod.payU) 'cashfree',
                                              if (selectedPayment == PaymentMethod.afterConsultation) 'pac',
                                              if (walletAppliedAmount > 0) 'wallet',
                                            ],

                                            walletAmount: walletAppliedAmount,
                                            paidAmount: 0,
                                            // paidAmount: payableAmount,
                                            orderStatus: 'processing',
                                            remainingAmount: selectedPayment == PaymentMethod.afterConsultation ? serviceAmount.toDouble() : (serviceAmount - payableAmount - walletAppliedAmount).clamp(0, double.infinity).toDouble(),
                                            paymentStatus: selectedPayment == PaymentMethod.afterConsultation ? 'unpaid' : 'pending',
                                            isPartialPayment: selectedPayment == PaymentMethod.payU ? selectedPayUOption == PayUOption.partial : false,
                                          );

                                          context.read<CheckoutBloc>().add(CheckoutRequestEvent(checkoutModel));
                                        },
                                      );
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
              ),
            );
          }

        return SizedBox.shrink();
      }
    );
  }

  Widget _paymentOptionWidgets(num serviceAmount, double partialAmount) {
    return CustomContainer(
      margin: EdgeInsets.zero,
      child: Column(
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
                      value: PaymentMethod.payU,
                      groupValue: selectedPayment,
                      activeColor: CustomColor.appColor,
                      onChanged: (value) => setState(() => selectedPayment = value),
                    ),
                    Text('CashFree Pay', style: textStyle14(context)),
                  ],
                ),

                if (selectedPayment == PaymentMethod.payU)
                  Column(
                    children: [
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _cashFreeOption("Full Payment", serviceAmount.toDouble(), PayUOption.full),
                          _cashFreeOption("Partial Payment", partialAmount, PayUOption.partial),
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
      ),
    );
  }

  Widget _cashFreeOption(String label, double amount, PayUOption option) {
    return Row(
      children: [
        Radio<PayUOption>(
          value: option,
          groupValue: selectedPayUOption,
          activeColor: CustomColor.appColor,
          onChanged: (value) => setState(() => selectedPayUOption = value!),
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
