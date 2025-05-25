import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:bizbooster2x/core/costants/text_style.dart';
import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';
import 'package:bizbooster2x/feature/checkout/widget/checkout_payment_done_widget.dart';
import 'package:bizbooster2x/feature/checkout/widget/check_payment_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widget/checkout_details_widget.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key,});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

  var _paymentStep = 0;

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  Widget build(BuildContext context) {

    Dimensions dimensions = Dimensions(context);
    return Scaffold(
      appBar: CustomAppBar(title: 'Checkout', showBackButton: true,),

      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            // 15.height,

            /// Tap section
            Container(
              color: CustomColor.whiteColor,
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _PaymentStep(context,
                        color:  _paymentStep == 0 ? CustomColor.appColor:null,
                        icon: CupertinoIcons.doc_fill, onTap: () {
                        setState(() {
                          _paymentStep = 0;
                        });
                      },),
                      _PaymentStep(context,
                        color:  _paymentStep == 1 ? CustomColor.appColor:null,
                        icon: Icons.payment, onTap: () {
                        setState(() {
                          _paymentStep = 1;
                        });
                      },),
                      _PaymentStep(context,
                        color:  _paymentStep == 2 ? CustomColor.appColor:null,
                        divider: false, icon: CupertinoIcons.checkmark_seal_fill, onTap: () {
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
            CheckoutDetailsWidget():
            _paymentStep ==1?
            CheckPaymentWidget():
            CheckoutPaymentDoneWidget(),
            50.height,
          ],
        ),
      )
      ),
    );
  }
}


/// Tap Section
Widget _PaymentStep(BuildContext context,{
  bool? divider = true,
  required IconData icon,
  Color? color,
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
          child: Icon(icon, color: color ?? CustomColor.greyColor,size: 20,),
        ),
      ),

      if( divider == true)
      CustomContainer(
        height:3,
        width: dimensions.screenHeight*0.12,
        padding: EdgeInsets.zero,
        backgroundColor: color ?? CustomColor.greyColor,)
    ],
  );
}

/// Tap Section
Widget _PaymentStepText(BuildContext context,String paymentStep){
  Dimensions dimensions = Dimensions(context);
  return Center(child: Text(paymentStep, style: textStyle12(context),));
}