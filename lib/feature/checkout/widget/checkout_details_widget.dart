import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_snackbar.dart';
import 'package:fetchtrue/core/widgets/formate_price.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';
import 'package:provider/provider.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_amount_text.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_favorite_button.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../../coupon/model/coupon_model.dart';
import '../../coupon/screen/coupon_screen.dart';
import '../../customer/bloc/customer/customer_bloc.dart';
import '../../customer/repository/customer_repository.dart';
import '../../customer/screen/add_customer_screen.dart';
import '../../customer/screen/customer_screen.dart';
import '../../service/bloc/service/service_bloc.dart';
import '../../service/bloc/service/service_event.dart';
import '../../service/bloc/service/service_state.dart';
import '../../service/model/service_model.dart';
import '../../service/repository/service_repository.dart';
import '../bloc/checkout/checkout_bloc.dart';
import '../bloc/checkout/checkout_state.dart';
import '../bloc/commission/commission_bloc.dart';
import '../bloc/commission/commission_event.dart';
import '../bloc/commission/commission_state.dart';
import '../model/checkout_model.dart';
import '../model/commission_model.dart';
import '../repository/checkout_repository.dart';

class CheckoutDetailsWidget extends StatefulWidget {
  final String serviceId;
  final String providerId;
  final String status;
  final Function(CheckOutModel, String zoneId, String couponCode) onPaymentDone;

  const CheckoutDetailsWidget({
    super.key,
    required this.onPaymentDone,
    required this.serviceId,
    required this.providerId,
    required this.status,
  });

  @override
  State<CheckoutDetailsWidget> createState() => _CheckoutDetailsWidgetState();
}

class _CheckoutDetailsWidgetState extends State<CheckoutDetailsWidget> {

  CouponModel? selectedCoupon;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CheckoutBloc(repository: CheckOutRepository()),
      child: BlocConsumer<CheckoutBloc, CheckoutState>(
        listener: (context, state) {
          if (state is CheckoutSuccess) {
            showCustomToast("Checkout successful");
            // widget.onPaymentDone(state.model);

            widget.onPaymentDone(state.model, selectedCoupon!.zone!.id.toString(), selectedCoupon!.couponCode.toString());

          } else if (state is CheckoutFailure) {
            showCustomToast(state.error);
          }
        },
        builder: (context, state) {
          if (state is CheckoutLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return BlocProvider(
            create: (_) => CommissionBloc()..add(GetCommission()),
            child: BlocBuilder<CommissionBloc, CommissionState>(
              builder: (context, state) {
                if (state is CommissionLoading) {
                  return LinearProgressIndicator(backgroundColor: CustomColor.appColor, color: CustomColor.whiteColor ,minHeight: 2.5,);
                } else if (state is CommissionLoaded) {
                  final commissionCharge = state.commission;
                  return  BlocProvider(
                    create: (_) => ServiceBloc(ServiceRepository())..add(GetServices()),
                    child: BlocBuilder<ServiceBloc, ServiceState>(
                      builder: (context, serviceState) {
                        if (serviceState is ServiceLoading) {
                          return LinearProgressIndicator(backgroundColor: CustomColor.appColor, color: CustomColor.whiteColor ,minHeight: 2.5,);
                        }
                        else if (serviceState is ServiceError) {
                          return Center(child: Text(serviceState.message));

                        } else if (serviceState is ServiceLoaded) {
                          final service = serviceState.services.firstWhereOrNull((s) => s.id == widget.serviceId,);

                          if (service == null) return const Text('No Service Found');

                          if(widget.status == 'default' || widget.status == 'outService'){
                            return CheckoutWidget(
                              service: service,
                              price: service.price.toString(),
                              discountPrice: service.discountedPrice.toString(),
                              discount: service.discount.toString(),
                              commission: service.franchiseDetails.commission.toString(),
                              providerId: widget.status == 'default' ? null : widget.providerId,
                              commissionCharge: commissionCharge,
                              onPaymentDone: widget.onPaymentDone,
                            );
                          }

                          else if(widget.status == 'inService'){
                            final providerPriceData = service.providerPrices.firstWhere((p) => p.provider?.id == widget.providerId,
                              orElse: () => service.providerPrices.isNotEmpty ? service.providerPrices.first : throw Exception('No provider price found'),
                            );
                            return CheckoutWidget(
                              service: service,
                              price: providerPriceData.providerMRP.toString(),
                              discountPrice: providerPriceData.providerPrice.toString(),
                              discount: providerPriceData.providerDiscount.toString(),
                              commission: providerPriceData.providerCommission.toString(),
                              providerId: widget.status == 'default' ? null : widget.providerId,
                              commissionCharge: commissionCharge,
                              onPaymentDone: widget.onPaymentDone,
                            );
                          }
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                  );
                } else if (state is CommissionError) {
                  print(state.message);
                }
                return Container();
              },
            ),
          );
        },
      ),
    );



  }
}


class CheckoutWidget extends StatefulWidget {
  final ServiceModel? service;
  final String price;
  final String discountPrice;
  final String discount;
  final String commission;
  final String? providerId;
  final CommissionModel commissionCharge;
  // final Function(CheckOutModel) onPaymentDone;
  final Function(CheckOutModel, String, String) onPaymentDone;

  const CheckoutWidget({
    super.key,
    required this.service,
    required this.price,
    required this.discountPrice,
    required this.discount,
    required this.commission,
    this.providerId,
    required this.commissionCharge,
    required this.onPaymentDone,
  });

  @override
  State<CheckoutWidget> createState() => _CheckoutWidgetState();
}

class _CheckoutWidgetState extends State<CheckoutWidget> {

  String? customer_Id;
  String? customerId;
  String? customerName;
  String? customerPhone;
  String? message;

  CouponModel? selectedCoupon;
  bool _isAgree = false;

  @override
  Widget build(BuildContext context) {
    final userSession = Provider.of<UserSession>(context);

    var listingPrice = double.tryParse(widget.price.toString()) ?? 0.0;
    var serviceDiscount = double.tryParse(widget.discount.toString()) ?? 0.0;


    var serviceDiscountPrice = (listingPrice * serviceDiscount) / 100;
    var serviceLessDiscountPrice = listingPrice - serviceDiscountPrice;

    double couponDiscount = 0.0;
    if (selectedCoupon != null) {
      var amount = double.tryParse(selectedCoupon!.amount.toString()) ?? 0.0;
      if (selectedCoupon!.discountAmountType == "Percentage") {
        couponDiscount = (serviceLessDiscountPrice * amount) / 100;
      } else {
        couponDiscount = amount;
      }
    }

    var finalPrice = serviceLessDiscountPrice - couponDiscount;
    if (finalPrice < 0) finalPrice = 0;


    /// add this
    var serviceGst = widget.service!.gst; // in %
    var platformFee = widget.commissionCharge.platformFee; // in amount
    var assurityFee = widget.commissionCharge.assurityFee; // in %

    var gstAmount = (finalPrice * serviceGst!) / 100;
    var platformFeeAmount = platformFee.toDouble();
    var assurityFeeAmount = (finalPrice * assurityFee) / 100;

    var grandTotal = finalPrice + gstAmount + platformFeeAmount + assurityFeeAmount;

    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                _serviceCard(context,
                  service: widget.service,
                  price: widget.price,
                  discountPrice: widget.discountPrice,
                  discount: widget.discount,
                  commission: widget.commission,
                ),

                /// Add customer
               _addCustomer(context,
                 customerName: customerName,
                 customerPhone: customerPhone,
                 customerMassage: message,
                 myCustomer: () async {
                   final selectedCustomer = await Navigator.push(context, MaterialPageRoute(builder: (context) =>  CustomerScreen(userId: userSession.userId,)),);

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
                 addCustomer: () async {
                   // final selectedCustomer = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddCustomerScreen(userId: userSession.userId),),);
                   final selectedCustomer = await Navigator.push(
                     context,
                     MaterialPageRoute(
                       builder: (context) => BlocProvider(
                         create: (_) => CustomerBloc(CustomerRepository()),
                         child: AddCustomerScreen(userId: userSession.userId),
                       ),
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
                 },
               ),
                10.height,


                _couponCard(context,
                    () async {
                    final selected = await Navigator.push(context, MaterialPageRoute(builder: (context) => const CouponScreen()),);
                    if (selected != null && selected is CouponModel) {
                      setState(() {
                        selectedCoupon = selected;
                      });
                    }
                    },
                    selectedCoupon,
                  ),
                10.height,



                CustomContainer(
                  color: CustomColor.whiteColor,
                  margin: EdgeInsetsGeometry.symmetric(horizontal: 10),
                  child: Column(spacing: 10,
                    children: [
                      _buildRow(context, 'Listing Price','₹ ${listingPrice.toStringAsFixed(2)}'),
                      _buildRow(context, 'Service Discount (${serviceDiscount.toStringAsFixed(0)} %)', '- ₹ ${serviceDiscountPrice.toStringAsFixed(2)}'),
                      _buildRow(context, 'Discount Price','₹ ${serviceLessDiscountPrice.toStringAsFixed(2)}'),
                      _buildRow(
                        context,
                        'Coupon Discount (${selectedCoupon != null ? '${selectedCoupon!.amount}${selectedCoupon!.discountAmountType == 'Percentage' ? ' %' : ' ₹'}' : '₹ 0'})',
                        '- ₹ ${couponDiscount.toStringAsFixed(2)}',
                      ),
                      _buildRow(context, 'Service GST (${serviceGst} %)','+ ${gstAmount.toStringAsFixed(2)}'),
                      _buildRow(context, 'Platform Fee (₹ ${platformFee})','+ ${platformFeeAmount.toStringAsFixed(2)}'),
                      _buildRow(context, 'Fetch True Assurity Charge (${assurityFee} %)','+ ${assurityFeeAmount.toStringAsFixed(2)}'),

                      Divider(height: 0,),
                      _buildRow(context, 'Grand Total', '₹ ${grandTotal.toStringAsFixed(2)}'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 15),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            activeColor: CustomColor.appColor,
                            value: _isAgree, onChanged: (value) {
                            setState(() {
                              _isAgree = !_isAgree;
                            });
                          },),
                          Text('I agree with the term  condition', style: textStyle12(context),)
                        ],
                      ),
                      10.height,
                      CustomButton(
                        isLoading: false,
                        label: 'Proceed', onPressed: ()async{
                          if(customerId == null){
                            showCustomToast('Please select customer');
                            return ;
                          }

                          if(!_isAgree){
                            showCustomToast('Please agree to the terms & conditions');
                            return;
                          }

                          String couponZoneId = selectedCoupon?.zone?.id.toString() ?? '';
                          String couponCode = selectedCoupon?.couponCode ?? '';

                          if(selectedCoupon != null && (couponZoneId.isEmpty || couponCode.isEmpty)){
                            showCustomToast("Coupon data is incomplete");
                            return;
                          }


                          final checkoutData = CheckOutModel(
                            user: userSession.userId.toString(),
                            provider: widget.providerId,
                            serviceCustomer: customer_Id.toString(),
                            notes: message.toString(),
                            service: widget.service!.id,
                            commission: widget.commission,
                            coupon: selectedCoupon?.id,
                            listingPrice: double.parse(listingPrice.toStringAsFixed(2)),
                            serviceDiscount: double.parse(serviceDiscount.toStringAsFixed(2)),
                            serviceDiscountPrice: double.parse(serviceDiscountPrice.toStringAsFixed(2)),
                            priceAfterDiscount: double.parse(serviceLessDiscountPrice.toStringAsFixed(2)),
                            couponDiscountPrice: double.parse(couponDiscount.toStringAsFixed(2)),
                            couponDiscount: double.parse((selectedCoupon?.amount.toDouble() ?? 0.0).toStringAsFixed(2)),
                            couponDiscountType: selectedCoupon?.discountAmountType == 'Percentage' ? '%' : '₹',
                            // couponDiscount: '${selectedCoupon != null ? '${selectedCoupon!.amount}${selectedCoupon!.discountAmountType == 'Percentage' ? ' %' : ' ₹'}' : '₹ 0'}',
                            gst: double.parse(serviceGst.toStringAsFixed(2)),
                            serviceGSTPrice: double.parse(gstAmount.toStringAsFixed(2)),
                            platformFee: double.parse(platformFee.toStringAsFixed(2)),
                            platformFeePrice: double.parse(platformFeeAmount.toStringAsFixed(2)),
                            assurityfee: double.parse(assurityFee.toStringAsFixed(2)),
                            assurityChargesPrice: double.parse(assurityFeeAmount.toStringAsFixed(2)),
                            subtotal: double.parse(serviceLessDiscountPrice.toStringAsFixed(2)),
                            grandTotal: double.parse(grandTotal.toStringAsFixed(2)),
                            totalAmount: double.parse(grandTotal.toStringAsFixed(2)),
                            champaignDiscount: 0.0,
                            termsCondition: _isAgree,
                          );

                          // print('provider Id :${widget.providerId}');
                         // widget.onPaymentDone(checkoutData);
                          widget.onPaymentDone(
                            checkoutData,
                            couponZoneId,
                            couponCode,
                          );


                      },)
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}


/// Service card
Widget _serviceCard(
    BuildContext context,
{
  ServiceModel? service,
  String? price,
  String? discountPrice,
  String? discount,
  String? commission,
}){

  String formatCommission(dynamic rawCommission, {bool half = false}) {
    if (rawCommission == null) return '0';

    final commissionStr = rawCommission.toString();

    // Extract numeric value
    final numericStr = commissionStr.replaceAll(RegExp(r'[^0-9.]'), '');
    final numeric = double.tryParse(numericStr) ?? 0;

    // Extract symbol (₹, %, etc.)
    final symbol = RegExp(r'[^\d.]').firstMatch(commissionStr)?.group(0) ?? '';

    final value = half ? (numeric / 2).round() : numeric.round();

    // Format with symbol
    if (symbol == '%') {
      return '$value%';
    } else {
      return '$symbol$value';
    }
  }

  return  CustomContainer(
    border: false,
    color: Colors.white,
    padding: EdgeInsets.zero,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomContainer(
          height: 160,
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          networkImg: service!.thumbnailImage.toString(),
          child: Align(
            alignment: Alignment.topRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                CustomFavoriteButton(),

                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    color: CustomColor.blackColor.withOpacity(0.3),
                  ),
                  child: Text('⭐ ${service!.averageRating} (${service!.totalReviews} ${'Reviews'})',
                    style: TextStyle(fontSize: 12, color:CustomColor.whiteColor ),
                  ),
                ),
              ],
            ),
          ),
        ),

        10.height,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(service!.serviceName.toString(), style: textStyle12(context)),
                  Row(
                    children: [
                      CustomAmountText(
                        amount: formatPrice(num.tryParse(price!) ?? 0),
                        color: CustomColor.descriptionColor,
                        isLineThrough: true,
                        fontSize: 14,
                      ),
                      10.width,
                      CustomAmountText(
                        amount: formatPrice(num.tryParse(discountPrice!) ?? 0),
                        color: CustomColor.descriptionColor,
                        fontSize: 14,
                      ),
                      10.width,
                      Text(
                        '$discount%',
                        style: textStyle14(
                          context,
                          color: CustomColor.greenColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Earn up to',
                    style: textStyle14(
                      context,
                      color: CustomColor.appColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    formatCommission(commission, half: true), style: textStyle16(context, color: CustomColor.greenColor,),
                  ),
                ],
              ),
            ],
          ),
        ),
        5.height
      ],
    ),
  );
}


/// Coupon Card
Widget _couponCard(BuildContext context, VoidCallback? onTap, CouponModel? selectedCoupon) {
  final isPercentage = selectedCoupon?.discountAmountType == 'Percentage';

  return CustomContainer(
    color: CustomColor.whiteColor,
    margin: EdgeInsetsGeometry.symmetric(horizontal: 10),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Best Coupon For You", style: textStyle12(context,)),
            InkWell(
              onTap: onTap,
              child: Text(
                selectedCoupon != null ? "Change Coupon" : "View Coupon",
                style: textStyle12(context, color: CustomColor.appColor),
              ),
            ),
          ],
        ),
        10.height,

        if (selectedCoupon != null)
          CustomContainer(
            border: true,
            color: Colors.transparent,
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${selectedCoupon.discountTitle}",
                  style: textStyle14(context, fontWeight: FontWeight.w500),
                ),
                5.height,
                Text(
                  "Coupon Code: #${selectedCoupon.couponCode}",
                  style: textStyle12(context, color: CustomColor.greenColor),
                ),
                5.height,
                Text(
                  "Offer: Save ${isPercentage ? '${selectedCoupon.amount}%' : '₹${selectedCoupon.amount}'}",
                  style: textStyle12(context, color: CustomColor.descriptionColor),
                ),
              ],
            ),
          ),

        if (selectedCoupon == null)
          CustomContainer(
            border: true,
            color: Colors.transparent,
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            child: Row(
              children: [
                Expanded(child: CustomContainer(
                  padding: EdgeInsets.only(left: 20),
                  height: 45,
                  child: TextField(
                    style: textStyle12(context),
                    decoration: InputDecoration(
                      hintText: '#XXXXXXX',
                      hintStyle: textStyle12(context, color: CustomColor.greyColor),
                      border: InputBorder.none
                    ),
                  ),
                )),
                CustomContainer(
                  height: 45,width: 100,
                  child: Center(child: Text('Apply', style: textStyle12(context),)),
                )
              ],
            ),
          ),
      ],
    ),
  );
}

Widget _buildRow(BuildContext context, label, amount){
  return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: textStyle12(context),),
        Text(amount, style: textStyle12(context),),
      ]
  );
}


Widget _addCustomer(
    BuildContext context, {
      String? customerName,
      String? customerPhone,
      String? customerMassage,
      VoidCallback? myCustomer,
      VoidCallback? addCustomer,
    }) {
  return CustomContainer(
    border: false,
    color: CustomColor.whiteColor,
    margin: EdgeInsets.symmetric(horizontal: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Customer',
          style: textStyle12(context,),
        ),
        const Divider(),

        if(customerName!= null)
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            'Name: ${customerName}',
            style: textStyle12(context, color: CustomColor.descriptionColor),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Phone: ${customerPhone}',
                style: textStyle12(context, color: CustomColor.descriptionColor),
              ),

              if (customerMassage != null && customerMassage.isNotEmpty)
              Text(
                'Notes: ${customerMassage}',
                style: textStyle12(context, color: CustomColor.descriptionColor),
              ),
            ],
          ),
        ),


        /// Buttons Row
        Row(
          children: [
            Expanded(
              child: _actionButton(
                context,
                icon: CupertinoIcons.person_crop_circle_badge_checkmark,
                label: "My Customer",
                onTap: myCustomer,
              ),
            ),
            10.width,
            Expanded(
              child: _actionButton(
                context,
                icon: Icons.add,
                label: "Add New Customer",
                onTap: addCustomer,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

/// Action Button
Widget _actionButton(
    BuildContext context, {
      required IconData icon,
      required String label,
      VoidCallback? onTap,
    }) {
  return CustomContainer(
    border: false,
    padding: const EdgeInsets.symmetric(vertical: 8),
    onTap: onTap,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: CustomColor.appColor, size: 16),
        8.width,
        Text(
          label,
          style: textStyle12(context, color: CustomColor.appColor),
        ),
      ],
    ),
  );
}
