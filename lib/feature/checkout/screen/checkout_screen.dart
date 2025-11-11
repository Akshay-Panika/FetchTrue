import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';
import '../model/checkout_model.dart';
import '../widget/check_payment_widget.dart';
import '../widget/checkout_details_widget.dart';
import '../widget/checkout_payment_done_widget.dart';

class CheckoutScreen extends StatefulWidget {
  final String serviceId;
  final String providerId;
  final String status;
  final bool isStore;
  const CheckoutScreen({super.key, required this.serviceId, required this.providerId, required this.status, required this.isStore,});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _paymentStep = 0;
  CheckOutModel? checkoutData;
  String? _bookingId;
  String? _dateTime;
  String? _amount;

  String zoneId = '';
  String couponCode = '';


  final steps = [
    {'icon': CupertinoIcons.doc_fill, 'label': 'Details'},
    {'icon': Icons.payment, 'label': 'Payment'},
    {'icon': CupertinoIcons.checkmark_seal_fill, 'label': 'Complete'},
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(title: 'Check Out', showBackButton: true),
      body: SafeArea(
        child: Column(
          children: [

            /// Section
            CustomContainer(
              margin: EdgeInsets.zero,
              borderRadius: false,
              color: CustomColor.whiteColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(steps.length, (index) {
                  return _PaymentStep(
                    icon: steps[index]['icon'] as IconData,
                    label: steps[index]['label'] as String,
                    isCompleted: _paymentStep > index,
                    isCurrent: _paymentStep == index,
                    isLast: index == steps.length - 1,
                    onTap: () {
                      // setState(() {
                      //   _paymentStep = index;
                      // });
                    },
                  );
                }),
              ),
            ),

            Expanded(
              child: Column(
                children: [
                  if (_paymentStep == 0)

                    /*
                    couponCode: couponCode,
                      zoneId: zoneId,  ye es esn se lena he
                     */
                    CheckoutDetailsWidget(
                     isStore: widget.isStore,
                     serviceId: widget.serviceId,
                      providerId: widget.providerId,
                      status: widget.status,
                      onPaymentDone: (CheckOutModel model, String zoneIdValue, String couponCodeValue) {
                        setState(() {
                          checkoutData = model;
                          zoneId = zoneIdValue;
                          couponCode = couponCodeValue;
                          _paymentStep = 1;
                        });
                      },
                    )

                  else if (_paymentStep == 1)
                    CheckPaymentWidget(
                      checkoutData: checkoutData!,
                      zoneId: zoneId,
                      onPaymentDone: (String bookingIdFromPayment, String dateTime, String amount ) {
                        setState(() {
                          _bookingId = bookingIdFromPayment;
                          _dateTime = dateTime;
                          _amount = amount;
                          _paymentStep = 2;
                        });
                      },
                    )
                  else
                     CheckoutPaymentDoneWidget(bookingId: _bookingId ??'', dateTime: _dateTime ?? '', amount: _amount ??'',),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _PaymentStep({
    required IconData icon,
    required String label,
    required bool isCompleted,
    required bool isCurrent,
    required bool isLast,
    required VoidCallback onTap,
  }) {
    final bool isActive = isCurrent || isCompleted;
    Dimensions dimensions = Dimensions(context);
    return Row(
      children: [
        InkWell(
          onTap: onTap,
          child: Column(
            children: [
              Icon(icon, color: isActive ? CustomColor.appColor : Colors.black54, size: 20,),
              4.height,
              Text(label,style: textStyle12(context, color: CustomColor.descriptionColor),),
            ],
          ),
        ),
        if (!isLast)
          Container(
            width: dimensions.screenHeight*0.1,
            height: 2,
            color: isActive ? CustomColor.appColor : Colors.grey.shade400,
            margin: const EdgeInsets.symmetric(horizontal: 6),
          ),
      ],
    );
  }
}

