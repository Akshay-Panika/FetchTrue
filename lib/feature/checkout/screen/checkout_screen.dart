import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';
import 'package:bizbooster2x/feature/checkout/widget/checkout_payment_done_widget.dart';
import 'package:bizbooster2x/feature/checkout/widget/check_payment_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../service/model/service_model.dart';
import '../model/check_out_model.dart';
import '../widget/checkout_details_widget.dart';

class CheckoutScreen extends StatefulWidget {
  final List<ServiceModel> services;

  const CheckoutScreen({super.key, required this.services});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _paymentStep = 0;
  CheckoutModel? checkoutData;

  final steps = [
    {'icon': CupertinoIcons.doc_fill, 'label': 'Details'},
    {'icon': Icons.payment, 'label': 'Payment'},
    {'icon': CupertinoIcons.checkmark_seal_fill, 'label': 'Complete'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Checkout', showBackButton: true),
      body: SafeArea(
        child: Column(
          children: [

            /// Section
            CustomContainer(
              backgroundColor: CustomColor.whiteColor,
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
                      setState(() {
                        _paymentStep = index;
                      });
                    },
                  );
                }),
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (_paymentStep == 0)
                      CheckoutDetailsWidget(
                        services: widget.services,
                        onPaymentDone: (CheckoutModel model) {
                          setState(() {
                            checkoutData = model;
                            _paymentStep = 1;
                          });
                        },
                      )

                    else if (_paymentStep == 1)
                      CheckPaymentWidget(
                        services: widget.services,
                        checkoutData: checkoutData!,
                        onPaymentDone: () {
                          setState(() => _paymentStep = 2);
                        },
                      )
                    else
                      const CheckoutPaymentDoneWidget(),
                  ],
                ),
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
    return Row(
      children: [
        InkWell(
          onTap: onTap,
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: isActive ? CustomColor.appColor : Colors.grey.shade300,
                radius: 20,
                child: Icon(
                  icon,
                  color: isActive ? Colors.white : Colors.black54,
                ),
              ),
              4.height,
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isActive ? CustomColor.appColor : Colors.grey,
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Container(
            width: 100,
            height: 2,
            color: isActive ? CustomColor.appColor : Colors.grey.shade400,
            margin: const EdgeInsets.symmetric(horizontal: 6),
          ),
      ],
    );
  }
}

