import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:bizbooster2x/core/costants/text_style.dart';
import 'package:bizbooster2x/core/widgets/custom_amount_text.dart';
import 'package:bizbooster2x/core/widgets/custom_headline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_ratting_and_reviews.dart';
import '../../customer/screen/customer_screen.dart';
import '../screen/submit_details_screen.dart';

class CheckoutDetailsWidget extends StatelessWidget {
  final String serviceBanner;
  const CheckoutDetailsWidget({super.key, required this.serviceBanner});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return Column(
      children: [

        /// Service
        CustomContainer(
          border: true,
          backgroundColor: CustomColor.whiteColor,
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomContainer(
                height: 150,
                networkImg: serviceBanner,
                margin: EdgeInsets.zero,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Service Name', style: textStyle14(context),),
                    CustomRattingAndReviews(),
                    5.height,


                    Row(
                      children: [
                        CustomAmountText(amount: '00.00', isLineThrough: true, color: CustomColor.descriptionColor),
                        10.width,
                        CustomAmountText(amount: '00.00', isLineThrough: false, fontSize: 14, fontWeight: FontWeight.w500, color: CustomColor.appColor),
                        10.width,

                        Text('00 % Discount', style: textStyle14(context, color: CustomColor.descriptionColor),)
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),



        /// Add customer
        CustomContainer(
          border: true,
          backgroundColor: CustomColor.whiteColor,
          child: Column(
            children: [
             Center(child: _buildHeadline(context, icon: CupertinoIcons.person_crop_circle_badge_checkmark, headline: 'My Customer')),

              10.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomContainer(
                    border: true,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.person_crop_circle_badge_checkmark, color: CustomColor.appColor,size: 16,),
                        10.width,
                        Text('My Customer', style: textStyle12(context, color: CustomColor.appColor),),
                      ],
                    ),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerScreen(),)),
                  ),
                  CustomContainer(
                    border: true,
                      onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SubmitDetailsScreen(),));
                      }, child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: CustomColor.appColor, size: 16,),
                          10.width,
                          Text('Add New Customer', style: textStyle12(context, color: CustomColor.appColor),),
                        ],
                      )),
                ],
              ),
            ],
          ),
        ),


        /// Best Coupon For You
        CustomContainer(
          border: true,
          backgroundColor: CustomColor.whiteColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: _buildHeadline(context, icon: CupertinoIcons.circle, headline: 'Best Coupon For You')),

              CustomContainer(
                border: true,
                width: double.infinity,
                borderColor: CustomColor.greenColor,
                backgroundColor: CustomColor.whiteColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Extra 00 Off', style: textStyle12(context),),
                    Text('You save an extra ₹00 with this coupon.', style: textStyle12(context, fontWeight: FontWeight.w400, color: CustomColor.descriptionColor),),

                    5.height,
                    Align(
                      alignment: Alignment.bottomRight,
                      child: CustomContainer(
                       border: true,
                        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                        child: Text('Apply Coupon', style: textStyle12(context, color: CustomColor.greenColor),),),
                    )
                  ],
                ),
              )

            ],
          ),
        ),


        CustomContainer(
          border: true,
          backgroundColor: CustomColor.whiteColor,
          child: Column(
            spacing: 10,
            children: [
              _buildRow(context,
              keys: 'Sub Total', amount: '00.00'),
              Divider(),
              _buildRow(context,
                  keys: 'Discount', amount: '00.00'),
              _buildRow(context,
                  keys: 'Campaign Discount', amount: '00.00'),

              _buildRow(context,
                  keys: 'Grand Total', amount: '00.00'),
              10.height,
            ],
          ),
        ),
        20.height,

      ],
    );
  }
}


Widget _buildHeadline(BuildContext context, { required IconData icon, required String headline}){
  return Row(
    children: [
     Icon(icon, size: 14,),
      5.width,
      Text(headline, style: textStyle12(context),)
    ],
  );
}


Widget _buildRow(BuildContext context, {required String keys, required String amount}){
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(keys, style: textStyle12(context),),
      CustomAmountText(amount: amount, fontWeight: FontWeight.w500)
    ],
  );
}