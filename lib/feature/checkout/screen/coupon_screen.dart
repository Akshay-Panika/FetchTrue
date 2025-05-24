import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:bizbooster2x/core/costants/text_style.dart';
import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';
import 'package:flutter/material.dart';

class CouponScreen extends StatelessWidget {
  const CouponScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Coupons', showBackButton: true,),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            10.height,
            _buildAppliedCouponCard(context),

            10.height,
            Padding(
              padding: EdgeInsets.only(left: 16,),
              child: Text("Other Coupons", style: textStyle14(context)),
            ),
            Column(
              children: List.generate(4, (index) => _buildCouponCard(context)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppliedCouponCard(BuildContext context) {
    return CustomContainer(
      backgroundColor: CustomColor.whiteColor,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Row(
            children: [
              Icon(Icons.check_box, color: Colors.red, size: 14,),
              SizedBox(width: 6),
              Text("Applied Coupon", style: textStyle12(context, color: CustomColor.redColor)),
            ],
          ),
           10.height,

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Extra ₹00 off", style: textStyle12(context)),
                  Text("You save an extra ₹00 with this coupon.", style: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomContainer(
                        border: true,
                        margin: EdgeInsets.zero,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        child:  Text("#ABCDE", style: textStyle12(context, color: CustomColor.greenColor)),
                      ),
                      CustomContainer(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        child:  Text("Apply Coupon", style: textStyle12(context, color: CustomColor.appColor)),
                      ),
                    ],
                  ),
                ],
              ),

            ],
          ),
          const Text("\u2022 15% off on minimum purchase of Rs. 000"),
          const Text("\u2022 Expires on : 31 March | 11:59 PM"),
        ],
      ),
    );
  }

  Widget _buildCouponCard(BuildContext context) {
    return CustomContainer(
      backgroundColor: CustomColor.whiteColor,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Extra ₹00 off", style: textStyle12(context)),
          Text("You save an extra ₹00 with this coupon.", style: textStyle12(context, fontWeight: FontWeight.w400, color: CustomColor.descriptionColor),),
          10.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomContainer(
                border: true,
                margin: EdgeInsets.zero,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child:  Text("#ABCDE", style: textStyle12(context, color: CustomColor.greenColor)),
              ),
              CustomContainer(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child:  Text("Apply Coupon", style: textStyle12(context, color: CustomColor.appColor)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
