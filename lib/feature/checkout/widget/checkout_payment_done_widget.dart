import 'package:fetchtrue/core/widgets/formate_price.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';

class CheckoutPaymentDoneWidget extends StatefulWidget {
  final String bookingId;
  final String dateTime;
  final String amount;
  const CheckoutPaymentDoneWidget({super.key, required this.bookingId, required this.dateTime, required this.amount});

  @override
  State<CheckoutPaymentDoneWidget> createState() => _CheckoutPaymentDoneWidgetState();
}

class _CheckoutPaymentDoneWidgetState extends State<CheckoutPaymentDoneWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward().whenComplete(() {
      if (!mounted) return;
    });
  }


  @override
  void dispose() {
    if (_controller.isAnimating) {
      _controller.stop();
    }
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);

    return Column(
      children: [
        SlideTransition(
          position: _offsetAnimation,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  40.height,
                  CustomContainer(
                    width: double.infinity,
                    color: CustomColor.whiteColor,
                    margin: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        50.height,
                        Text('Your place the lead successfully',
                            style: textStyle18(context, color: CustomColor.appColor)),
                        Text('Thank you for your order with us',
                            style: textStyle14(context, color: CustomColor.descriptionColor)),
                        SizedBox(height: dimensions.screenHeight*0.1,),
                        Divider(),
                        10.height,
                        // Center(child: Text('Total Payment')),
                        // 10.height,
                        // Center(child: Text('₹ ${widget.amount}', style: textStyle22(context))),
                        // 50.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Lead Id', style: textStyle14(context, color: CustomColor.descriptionColor)),
                            Text(widget.bookingId, style: textStyle14(context, color: CustomColor.descriptionColor)),
                          ],
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Date & Time', style: textStyle14(context, color: CustomColor.descriptionColor)),
                            Text('${formatDateTime(widget.dateTime)}', style: textStyle14(context, color: CustomColor.descriptionColor)),
                          ],
                        ),
                        SizedBox(height: dimensions.screenHeight * 0.05),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 30,
                child: Icon(Icons.verified, size: 60, color: Colors.green),
              ),
            ],
          ),
        ),
        100.height,
        CustomContainer(
          width: dimensions.screenHeight*0.2,
          border: true,
          color: Colors.transparent,
          // color: CustomColor.whiteColor,
          child: Center(child: Text("Go Back", style: textStyle16(context, color: CustomColor.appColor))),
            onTap: () {
              if (mounted) {
                context.go('/dashboard');
              }
            }

        )
      ],
    );
  }
}
