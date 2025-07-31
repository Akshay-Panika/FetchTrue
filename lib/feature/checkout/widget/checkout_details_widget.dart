import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_amount_text.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../../coupon/model/coupon_model.dart';
import '../../customer/screen/customer_screen.dart';
import '../../coupon/screen/coupon_screen.dart';
import '../../service/model/service_model.dart';
import '../model/checkout_model.dart';
import '../model/summery_model.dart';
import '../repository/summery_service.dart';
import '../screen/add_customer_screen.dart';

class CheckoutDetailsWidget extends StatefulWidget {
  final String providerId;
  final List<ServiceModel> services;
  // final VoidCallback onPaymentDone;
  final Function(CheckOutModel) onPaymentDone;
  const CheckoutDetailsWidget({super.key, required this.services, required this.onPaymentDone, required this.providerId,});

  @override
  State<CheckoutDetailsWidget> createState() => _CheckoutDetailsWidgetState();
}

class _CheckoutDetailsWidgetState extends State<CheckoutDetailsWidget> {


  String? customer_Id;
  String? customerId;
  String? customerName;
  String? customerPhone;
  String? message;


  bool _isAgree = false;
  CouponModel? selectedCoupon;

  CommissionModel? _commission;

  @override
  void initState() {
    super.initState();
    loadCommission();
  }

  Future<void> loadCommission() async {
    final result = await CommissionService.fetchCommission();
    if (result != null) {
      setState(() {
        _commission = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var data = widget.services.first;
    final userSession = Provider.of<UserSession>(context);
    Dimensions dimensions = Dimensions(context);

    final double originalPrice = data.price?.toDouble() ?? 0.0;
    final double serviceDiscountPercent = data.discount?.toDouble() ?? 0.0;
    final double serviceDiscountAmount = originalPrice * serviceDiscountPercent / 100;
    final double afterServiceDiscountPrice = originalPrice - serviceDiscountAmount;

    double couponDiscountAmount = 0.0;
    if (selectedCoupon != null) {
      if (selectedCoupon!.discountAmountType == 'Percentage') {
        couponDiscountAmount = afterServiceDiscountPrice * (selectedCoupon!.amount.toDouble()) / 100;
      } else {
        couponDiscountAmount = selectedCoupon!.amount.toDouble();
      }
    }
    final double afterCouponPrice = afterServiceDiscountPrice - couponDiscountAmount;

// ✅ GST, Platform Fee, Assurity Fee Calculate करो
    final double gstPercent = data.gst?.toDouble() ?? 0.0;
    final double platformFeePercent = _commission?.platformFee?.toDouble() ?? 0.0;
    final double assurityFeePercent = _commission?.assurityFee?.toDouble() ?? 0.0;

    final double gstAmount = afterCouponPrice * gstPercent / 100;
    final double platformFeeAmount = afterCouponPrice * platformFeePercent / 100;
    final double assurityFeeAmount = afterCouponPrice * assurityFeePercent / 100;

    final double grandTotal = afterCouponPrice + gstAmount + platformFeeAmount + assurityFeeAmount;

    // String removeTrailingZero(double value) {
    //   if (value == value.toInt()) {
    //     return value.toInt().toString();
    //   }
    //   return value.toStringAsFixed(2);
    // }

    String formatPrice(num value) {
      return value.round().toString();
    }


    return Column(
      children: [

        /// Service
        CustomContainer(
          border: false,
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

        _buildCommissionCard(context, commission: data.franchiseDetails.commission),

        /// Add customer
        CustomContainer(
          border: false,
          backgroundColor: CustomColor.whiteColor,
          margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
          child: Column(
            children: [
             Center(child: _buildHeadline(context, icon: CupertinoIcons.text_badge_checkmark, headline: 'Select Customer')),

              if(customerName!= null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  10.height,
                  ListTile(
                   minTileHeight: 0,
                   minVerticalPadding: 0,
                   contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Name: ${customerName ?? '_____'}',
                      style: textStyle12(context, color: CustomColor.descriptionColor),
                    ),
                    subtitle: Column(
                      crossAxisAlignment:CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Phone: ${customerPhone ?? '_____'}',
                          style: textStyle12(context, color: CustomColor.descriptionColor),
                        ),

                        if(message!.isNotEmpty)
                        Text('Notes: ${message??'_____'}',
                          style: textStyle12(context, color: CustomColor.descriptionColor),
                        ),
                      ],
                    ), ),
                ],
              ),

              10.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomContainer(
                      border: true,
                      padding: EdgeInsets.symmetric(vertical: 8),
                      onTap: () async {
                        final selectedCustomer = await Navigator.push(context, MaterialPageRoute(builder: (context) =>  CustomerScreen(userId: userSession.userId.toString(),)),);

                        if (selectedCustomer != null) {
                          setState(() {
                            customer_Id = selectedCustomer['_id'];
                            customerId = selectedCustomer['userId'];
                            customerName = selectedCustomer['fullName'];
                            customerPhone = selectedCustomer['phone'];
                            message = selectedCustomer['message'];
                          });
                        }
                      },
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
                        onTap: () async {
                          final selectedCustomer = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddCustomerScreen(userId: userSession.userId!),
                            ),
                          );

                          if (selectedCustomer != null) {
                            setState(() {
                              customer_Id = selectedCustomer['_id'];
                              customerId = selectedCustomer['userId'];
                              customerName = selectedCustomer['fullName'];
                              customerPhone = selectedCustomer['phone'];
                              message = selectedCustomer['message'];
                            });
                          }
                        }
                    ),
                  ),

                ],
              ),
            ],
          ),
        ),

        /// Best Coupon For You
        CustomContainer(
          border: false,
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
                    onTap: () async {
                      final selected = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CouponScreen()),
                      );

                      if (selected != null && selected is CouponModel) {
                        setState(() {
                          selectedCoupon = selected;
                        });
                      }
                    },
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

              if (selectedCoupon != null) ...[
                CustomContainer(
                  border: true,
                  width: double.infinity,
                  borderColor: CustomColor.greenColor,
                  backgroundColor: CustomColor.whiteColor,
                  margin: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Extra ${selectedCoupon!.amount}${selectedCoupon!.discountAmountType == 'Percentage' ? '%' : ''} Off', style: textStyle12(context)),
                      Text(
                        'You save an extra ₹${selectedCoupon!.amount} with this coupon.',
                        style: textStyle12(context, fontWeight: FontWeight.w400, color: CustomColor.descriptionColor),
                      ),
                      10.height,
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: CustomContainer(
                              border: true,
                              height: 40,
                              margin: EdgeInsets.zero,
                              child: Center(
                                child: Text(
                                  "#${selectedCoupon!.couponCode}",
                                  style: textStyle14(context, color: CustomColor.greenColor),
                                ),
                              ),
                            ),
                          ),
                          10.width,
                          Expanded(
                            child: CustomContainer(
                              border: true,
                              height: 40,
                              margin: EdgeInsets.zero,
                              child: Center(
                                child: Text(
                                  'Applied',
                                  style: textStyle12(context, color: CustomColor.appColor),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ] else ...[
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
              ],

              10.height,

            ],
          ),
        ),


        /// Summery
        CustomContainer(
          border: false,
          backgroundColor: CustomColor.whiteColor,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            spacing: 10,
            children: [

              _buildRow(
                context,
                title: 'Listing Price',
                amount: '₹ ${formatPrice(originalPrice)}',
              ),

              _buildRow(
                context,
                title: 'Service Discount (${serviceDiscountPercent.toStringAsFixed(0)} %)',
                amount: '- ₹ ${formatPrice(serviceDiscountAmount)}',
              ),

              _buildRow(
                context,
                title: 'Price After Discount',
                amount: '₹ ${formatPrice(afterServiceDiscountPrice)}',
              ),

              _buildRow(
                context,
                title:
                'Coupon Discount (${selectedCoupon != null ? '${selectedCoupon!.amount}${selectedCoupon!.discountAmountType == 'Percentage' ? ' %' : ' ₹'}' : '₹ 0'})',
                amount: '- ₹ ${formatPrice(couponDiscountAmount)}',
              ),

              _buildRow(
                context,
                title: 'Service GST (${gstPercent.toStringAsFixed(0)} %)',
                amount: '+ ₹ ${formatPrice(gstAmount)}',
              ),
              _buildRow(
                context,
                title: 'Platform Fee (${platformFeePercent.toStringAsFixed(0)} %)',
                amount: '+ ₹ ${formatPrice(platformFeeAmount)}',
              ),
              _buildRow(
                context,
                title: 'Fetch True Assurity Charges (${assurityFeePercent.toStringAsFixed(0)} %)',
                amount: '+ ₹ ${formatPrice(assurityFeeAmount)}',
              ),
              Divider(thickness: 0.4),

              _buildRow(
                context,
                title: 'Grand Total',
                amount: '₹ ${formatPrice(grandTotal)}',
              ),
            ],
          ),
        ),

        Row(
          children: [
            Checkbox(value: _isAgree, onChanged: (value) {
              setState(() {
                _isAgree = !_isAgree;
              });
            }, activeColor: Colors.green,),
            Text('I agree with the term & condition')
          ],
        ),
        15.height,

        Padding(
          padding: const EdgeInsets.all(10),
          child: CustomButton(
            isLoading: false,
            onPressed: () async {
              if (customerId == null) {
                showCustomSnackBar(context, 'Please select customer.');
                return;
              }

              if (!_isAgree) {
                showCustomSnackBar(context, 'Please agree to the terms & conditions.');
                return;
              }

              final fetchTure = 'fetchTure';

              /// Model
              final checkoutData = CheckOutModel(
                  user: userSession.userId.toString(),
                  service: data.id,
                  serviceCustomer: customer_Id.toString(),
                  provider: widget.providerId == fetchTure ? null : widget.providerId.isNotEmpty == true ? widget.providerId : null,
                  coupon: selectedCoupon?.id,
                  subtotal: (data.discountedPrice ?? 0).toInt(),
                  serviceDiscount: (data.discount ?? 0).toInt(),
                  couponDiscount: selectedCoupon?.amount ?? 0,
                  champaignDiscount: 0,
                  gst: data.gst ??0,
                  platformFee: _commission?.platformFee,
                  assurityfee:_commission?.assurityFee,
                  // totalAmount: data.discountedPrice?.toInt(),
                  totalAmount: grandTotal.toInt(),
                  paymentMethod: [],
                  walletAmount: 0,
                  otherAmount: 0,
                  paidAmount: 0,
                  remainingAmount: 0,
                  isPartialPayment: false,
                  paymentStatus: '',
                  orderStatus: '',
                  notes: message ?? '',
                  termsCondition: _isAgree,
                  listingPrice: originalPrice.toInt(),
                  serviceDiscountPrice: serviceDiscountAmount.toInt(),
                  priceAfterDiscount: afterServiceDiscountPrice.toInt(),
                  couponDiscountPrice: couponDiscountAmount.toInt(),
                  serviceGSTPrice: gstAmount.toInt(),
                  platformFeePrice: platformFeeAmount.toInt(),
                  assurityChargesPrice: assurityFeeAmount.toInt(),
              );
              print("✅ serviceGSTPrice in model: ${checkoutData.serviceGSTPrice}");
              print("📦 Final Payload: ${checkoutData.toJson()}");
              widget.onPaymentDone(checkoutData);
            },
            label: 'Proceed',
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


Widget _buildRow(BuildContext context, {required String title, required String amount,}){
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(title, style: textStyle12(context),),
      Text(amount, style: textStyle12(context),),
    ],
  );
}

Widget _buildCommissionCard(BuildContext context, {required String commission}){
  return CustomContainer(
    border: false,
    width: double.infinity,
    backgroundColor: CustomColor.whiteColor,
    margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
    child:  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('You Will Earn Commission', style: textStyle14(context, color: CustomColor.appColor),)  ,
        Row(
          children: [
            Text('Up To', style: textStyle12(context),),
            10.width,
            Text('${commission}', style: textStyle14(context, color: Colors.green),),
          ],
        )  ,
      ],
    ),
  );
}
