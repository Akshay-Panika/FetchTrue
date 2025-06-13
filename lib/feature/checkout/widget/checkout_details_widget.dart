import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/core/costants/custom_image.dart';
import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:bizbooster2x/core/costants/text_style.dart';
import 'package:bizbooster2x/core/widgets/custom_amount_text.dart';
import 'package:bizbooster2x/core/widgets/custom_button.dart';
import 'package:bizbooster2x/core/widgets/custom_headline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_ratting_and_reviews.dart';
import '../../customer/screen/customer_screen.dart';
import '../../coupon/screen/coupon_screen.dart';
import '../../service/model/service_model.dart';
import '../screen/new_submit_details_screen.dart';
import '../screen/submit_details_screen.dart';

class CheckoutDetailsWidget extends StatefulWidget {
  final List<ServiceModel> services;
  const CheckoutDetailsWidget({super.key, required this.services,});

  @override
  State<CheckoutDetailsWidget> createState() => _CheckoutDetailsWidgetState();
}

class _CheckoutDetailsWidgetState extends State<CheckoutDetailsWidget> {


  String? customerName;
  String? customerPhone;

  @override
  Widget build(BuildContext context) {
    var data = widget.services.first;


    Dimensions dimensions = Dimensions(context);
    return Column(
      children: [

        /// Service
        CustomContainer(
          border: true,
          backgroundColor: CustomColor.whiteColor,
          padding: EdgeInsets.zero,
          margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomContainer(
                height: 150,
                networkImg: '${data.thumbnailImage}',
                margin: EdgeInsets.zero,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${data.serviceName}'?? 'Service Name', style: textStyle14(context),),
                    CustomRattingAndReviews(),
                    5.height,


                    Row(
                      children: [
                        CustomAmountText(amount: '${data.price}'??'00.00', isLineThrough: true, color: CustomColor.descriptionColor,fontSize: 14),
                        10.width,
                        CustomAmountText(amount: '${data.discountedPrice}'??'00.00', isLineThrough: false, fontSize: 14, color: CustomColor.appColor),
                        10.width,

                        Text('${data.discount} % Discount'??'00 Discount', style: textStyle14(context, color: CustomColor.greenColor, fontWeight: FontWeight.w400),)
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
          margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
          child: Column(
            children: [
             Center(child: _buildHeadline(context, icon: CupertinoIcons.text_badge_checkmark, headline: 'Select Customer')),
              10.height,

              ListTile(
               minTileHeight: 0,
               minVerticalPadding: 0,
               contentPadding: EdgeInsets.zero,
                title: Text(
                  'Name: ${customerName ?? '_____'}',
                  style: textStyle12(context, color: CustomColor.descriptionColor),
                ),
                subtitle: Text(
                  'Phone: ${customerPhone ?? '_____'}',
                  style: textStyle12(context, color: CustomColor.descriptionColor),
                ), ),

              10.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomContainer(
                      border: true,
                      padding: EdgeInsets.symmetric(vertical: 8),
                      onTap: () async {
                        final selectedCustomer = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CustomerScreen()),
                        );

                        if (selectedCustomer != null) {
                          setState(() {
                            customerName = selectedCustomer['fullName'];
                            customerPhone = selectedCustomer['phone'];
                          });
                        }
                      },

                      // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerScreen(),)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.person_crop_circle_badge_checkmark, color: CustomColor.appColor,size: 16,),
                          10.width,
                          Text('My Customer', style: textStyle12(context, color: CustomColor.appColor),),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: CustomContainer(
                      border: true,
                      padding: EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, color: CustomColor.appColor, size: 16,),
                            10.width,
                            Text('Add New Customer', style: textStyle12(context, color: CustomColor.appColor),),
                          ],
                        ),
                        onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => NewSubmitDetailsScreen(),));
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => SubmitDetailsScreen(),));
                      },
                    ),
                  ),

                ],
              ),
            ],
          ),
        ),

        /// Best Coupon For You
        CustomContainer(
          border: true,
          backgroundColor: CustomColor.whiteColor,
          margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(child: _buildHeadline(context, icon: Icons.card_giftcard, headline: 'Best Coupon For You')),

                  InkWell(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CouponScreen(),)),
                    child: Row(
                      children: [
                        Text('See All', style: textStyle12(context),),
                        5.width,
                        Icon(Icons.arrow_forward_ios, size: 12,)
                      ],
                    ),
                  )
                ],
              ),
              10.height,

              CustomContainer(
                border: true,
                width: double.infinity,
                borderColor: CustomColor.greenColor,
                backgroundColor: CustomColor.whiteColor,
                margin: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Extra 00 Off', style: textStyle12(context),),
                    Text('You save an extra ₹00 with this coupon.', style: textStyle12(context, fontWeight: FontWeight.w400, color: CustomColor.descriptionColor),),

                    10.height,
                    Row(
                      children: [
                        Expanded(flex: 3,
                            child: CustomContainer(
                              border: true,
                              height: 40,
                              margin: EdgeInsets.zero,
                              child: TextField(
                                style: textStyle14(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),
                                decoration: InputDecoration(
                              border: InputBorder.none,
                              suffixIcon: Icon(CupertinoIcons.check_mark_circled, color: CustomColor.appColor,size: 18,),
                              labelStyle: textStyle14(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),
                              hintText: 'Type Coupon Here...',
                                ),
                              ),
                            )),

                        10.width,
                        Expanded(
                          child: CustomContainer(
                           border: true,
                            height: 40,
                            margin: EdgeInsets.zero,
                            child: Center(child: Text('Apply', style: textStyle12(context, color: CustomColor.appColor),)),),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              10.height,

            ],
          ),
        ),

        /// Summery
        CustomContainer(
          border: true,
          backgroundColor: CustomColor.whiteColor,
          margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
          child: Column(
            spacing: 10,
            children: [
              _buildRow(context,
              keys: 'Sub Total', amount: '${data.discountedPrice}'),
              Divider(),
              _buildRow(context, keys: 'Service Discount', amount: '00.00'),
              _buildRow(context, keys: 'Coupon Discount', amount: '00.00'),
              _buildRow(context, keys: 'Campaign Discount', amount: '00.00'),
              _buildRow(context, keys: 'Service Vat', amount: '00.00'),
              _buildRow(context, keys: 'Grand Total', amount: '00.00'),
              10.height,
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(10),
          child: CustomButton(
            onPressed: () => null,
            label: 'Proceed',),
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