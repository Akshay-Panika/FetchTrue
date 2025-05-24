import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:bizbooster2x/core/costants/text_style.dart';
import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';
import 'package:bizbooster2x/feature/checkout/screen/payment_done_screen.dart';
import 'package:bizbooster2x/feature/checkout/screen/payment_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widget/checkout_details_widget.dart';

class CheckoutScreen extends StatefulWidget {
  final String serviceBanner;
  const CheckoutScreen({super.key, required this.serviceBanner});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

  var _paymentStep = 0;

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  Widget build(BuildContext context) {

    Dimensions dimensions = Dimensions(context);
    return Scaffold(
      // backgroundColor: CustomColor.whiteColor,
      appBar: CustomAppBar(title: 'Checkout', showBackButton: true,),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            15.height,

            /// Tap section
            Container(
              color: CustomColor.whiteColor,
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _PaymentStep(context, icon: CupertinoIcons.pen, onTap: () {
                        setState(() {
                          _paymentStep = 0;
                        });
                      },),
                      _PaymentStep(context, icon: Icons.payment, onTap: () {
                        setState(() {
                          _paymentStep = 1;
                        });
                      },),
                      _PaymentStep(context,divider: false, icon: CupertinoIcons.check_mark_circled, onTap: () {
                      setState(() {
                        _paymentStep = 2;
                      });
                      },),
                    ],
                  ),
                  5.height,

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _PaymentStepText(context,'Details'),
                        _PaymentStepText(context,'    Payment'),
                        _PaymentStepText(context,'Complete'),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: dimensions.screenHeight*0.01,),

            /// Service
            _paymentStep ==0?
            CheckoutDetailsWidget(serviceBanner: widget.serviceBanner,):
            _paymentStep ==1?
            PaymentScreen():
            PaymentDoneScreen(),
            50.height,
          ],
        ),
      )),
    );
  }
}


/// Tap Section
Widget _PaymentStep(BuildContext context,{
  bool? divider = true,
  required IconData icon,
  VoidCallback? onTap,
}){

  Dimensions dimensions = Dimensions(context);
  return Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      InkWell(
        onTap: onTap,
        child: CircleAvatar(
          backgroundColor: CustomColor.canvasColor,
          child: Icon(icon, color: CustomColor.appColor,),
        ),
      ),

      if( divider == true)
      CustomContainer(
        height:3,
        width: dimensions.screenHeight*0.12,
        padding: EdgeInsets.zero,
        backgroundColor: CustomColor.appColor,)
    ],
  );
}

/// Tap Section
Widget _PaymentStepText(BuildContext context,String paymentStep){
  Dimensions dimensions = Dimensions(context);
  return Center(child: Text(paymentStep, style: textStyle12(context),));
}