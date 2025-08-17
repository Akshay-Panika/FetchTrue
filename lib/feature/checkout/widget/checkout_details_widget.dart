import 'package:fetchtrue/feature/provider/repository/provider_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_amount_text.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../../../core/widgets/formate_price.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../../coupon/model/coupon_model.dart';
import '../../coupon/screen/coupon_screen.dart';
import '../../customer/screen/add_customer_screen.dart';
import '../../customer/screen/customer_screen.dart';
import '../../provider/bloc/provider/provider_bloc.dart';
import '../../provider/bloc/provider/provider_event.dart';
import '../../provider/bloc/provider/provider_state.dart';
import '../../service/bloc/module_service/module_service_bloc.dart';
import '../../service/bloc/module_service/module_service_event.dart';
import '../../service/bloc/module_service/module_service_state.dart';
import '../../service/repository/api_service.dart';
import '../bloc/commission/commission_bloc.dart';
import '../bloc/commission/commission_event.dart';
import '../bloc/commission/commission_state.dart';
import '../model/checkout_model.dart';

class CheckoutDetailsWidget extends StatefulWidget {
  final String serviceId;
  final String providerId;
  final String status;
  final Function(CheckOutModel) onPaymentDone;
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
  double _toDoubleSafe(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

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
    Dimensions dimensions = Dimensions(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ModuleServiceBloc(ApiService())..add(GetModuleService()),),
        BlocProvider(
          create: (_) => ProviderBloc(ProviderRepository())..add(GetProviders()),
        ),
        BlocProvider(
          create: (_) => CommissionBloc()..add(GetCommissionEvent()),
        ),
      ],
      child: BlocBuilder<ModuleServiceBloc, ModuleServiceState>(
        builder: (context, serviceState) {
          if (serviceState is ModuleServiceLoading) {
            return LinearProgressIndicator(backgroundColor: CustomColor.appColor, color: CustomColor.whiteColor ,minHeight: 2.5,);

          } else if (serviceState is ModuleServiceLoaded) {
            final service = serviceState.serviceModel.firstWhere(
                  (s) => s.id == widget.serviceId,
              orElse: () => serviceState.serviceModel.first,
            );

            if (service.id == null || service.id!.isEmpty) {
              return const Center(child: Text('Service not found'));
            }

            return BlocBuilder<ProviderBloc, ProviderState>(
              builder: (context, providerState) {
                if (providerState is ProviderLoading) {
                  return LinearProgressIndicator(backgroundColor: CustomColor.appColor, color: CustomColor.whiteColor ,minHeight: 2.5,);

                } else if (providerState is ProviderLoaded) {
                  double price;
                  double discountedPrice;
                  double discountPercent;
                  String commissionPrice;

                  if (widget.status == "default" || widget.status == "outService") {
                    price = _toDoubleSafe(service.price);
                    discountedPrice = _toDoubleSafe(service.discountedPrice);
                    discountPercent = _toDoubleSafe(service.discount);
                    commissionPrice = service.franchiseDetails.commission;
                  } else if (widget.status == "inService") {
                    final providerPriceData = service.providerPrices.firstWhere((p) => p.provider?.id == widget.providerId,
                      orElse: () => service.providerPrices.isNotEmpty ? service.providerPrices.first : throw Exception('No provider price found'),
                    );
                    price = _toDoubleSafe(providerPriceData.providerMRP);
                    discountedPrice = _toDoubleSafe(providerPriceData.providerPrice);
                    discountPercent = _toDoubleSafe(providerPriceData.providerDiscount);
                    commissionPrice =   providerPriceData.providerCommission.toString();
                  } else {
                    price = 0.0;
                    discountedPrice = 0.0;
                    discountPercent = 0.0;
                    commissionPrice = '00';
                  }

                  return BlocBuilder<CommissionBloc, CommissionState>(
                    builder: (context, commissionState) {
                      int platformFee = 0;
                      double assurityFee = 0;

                      if (commissionState is CommissionLoaded) {
                        platformFee =
                            commissionState.commission.platformFee.toInt();
                        assurityFee =
                            commissionState.commission.assurityFee.toDouble();
                      }

                      // Coupon Discount calculation
                      double couponDiscount = 0.0;
                      if (selectedCoupon != null) {
                        if (selectedCoupon!.discountAmountType == 'Percentage') {
                          couponDiscount =
                              discountedPrice * selectedCoupon!.amount / 100;
                        } else {
                          couponDiscount =
                              selectedCoupon!.amount.toDouble();
                        }
                      }

                      // GST calculation
                      double gstAmount =
                          discountedPrice * _toDoubleSafe(service.gst) / 100;

                      // Assurity charge
                      double assurityCharge =
                          discountedPrice * assurityFee / 100;

                      // // Grand total calculation
                      // double grandTotal = discountedPrice -
                      //     couponDiscount +
                      //     gstAmount +
                      //     assurityCharge +
                      //     platformFee;

                      double calculateGrandTotal({
                        required double discountedPrice,
                        required double couponDiscount,
                        required double gstAmount,
                        required double assurityCharge,
                        required int platformFee,
                      }) {
                        double total = discountedPrice - couponDiscount + gstAmount + assurityCharge + platformFee;

                        // Agar decimal hai to ceil karo, warna floor karo
                        return total % 1 == 0 ? total.floorToDouble() : total.ceilToDouble();
                      }

                      double grandTotal = calculateGrandTotal(
                        discountedPrice: discountedPrice,
                        couponDiscount: couponDiscount,
                        gstAmount: gstAmount,
                        assurityCharge: assurityCharge,
                        platformFee: platformFee,
                      );


                      return Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  children: [
                                    10.height,
                                    /// Service Card
                                    CustomContainer(
                                      padding: EdgeInsets.zero,
                                      color: CustomColor.whiteColor,
                                      margin: EdgeInsets.zero,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CustomContainer(
                                            height: 150,
                                            networkImg: service.thumbnailImage,
                                            margin: EdgeInsets.zero,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text(service.serviceName,
                                                    style: textStyle14(context)),
                                                Row(
                                                  spacing: 10,
                                                  children: [
                                                    CustomAmountText(
                                                      amount: formatPrice(price),
                                                      color:
                                                      CustomColor.descriptionColor,
                                                      isLineThrough: true,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                    CustomAmountText(
                                                      amount:
                                                      formatPrice(discountedPrice),
                                                      color: CustomColor.appColor,
                                                      isLineThrough: false,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                    Text(
                                                      '$discountPercent % Off',
                                                      style: textStyle14(
                                                        context,
                                                        color: CustomColor.greenColor,
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    10.height,

                                    /// Commission
                                    CustomContainer(
                                      color: CustomColor.whiteColor,
                                      margin: EdgeInsets.zero,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('You Will Earn Commission', style: textStyle14(context, color: CustomColor.appColor),),
                                          Row(
                                            children: [
                                              Text('Up To', style: textStyle14(context),),
                                              10.width,
                                              // Text(widget.status == "default" ? '${service.franchiseDetails.commission}': commissionPrice, style: textStyle14(context, color: CustomColor.greenColor),),
                                              Text(commissionPrice, style: textStyle14(context, color: CustomColor.greenColor),),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    10.height,

                                    /// Add customer
                                    CustomContainer(
                                      border: false,
                                      color: CustomColor.whiteColor,
                                      margin: EdgeInsets.zero,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Select Customer',),
                                          Divider(),

                                          if(customerName!= null)
                                           Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [

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
                                    10.height,

                                    /// Best Coupon For You
                                    CustomContainer(
                                      border: false,
                                      color: CustomColor.whiteColor,
                                      margin: EdgeInsets.zero,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                             Text('Best Coupon For You'),

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
                                              color: CustomColor.whiteColor,
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
                                              color: CustomColor.whiteColor,
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
                                    10.height,

                                    CustomContainer(
                                      color: Colors.white,
                                      margin: EdgeInsets.zero,
                                      child: Column(
                                        spacing: 10,
                                        children: [
                                          _summeryText(context,
                                              label: 'Listing Price',
                                              value: '₹ ${formatPrice(price)}'),
                                          _summeryText(context,
                                              label:
                                              'Service Discount (${formatPrice(discountPercent)} %)',
                                              value:
                                              '- ₹ ${formatPrice(price - discountedPrice)}'),
                                          _summeryText(context,
                                              label: 'Price After Discount',
                                              value:
                                              '₹ ${formatPrice(discountedPrice)}'),
                                          _summeryText(context,
                                              label:
                                              'Coupon Discount (${selectedCoupon != null ? '${selectedCoupon!.amount}${selectedCoupon!.discountAmountType == 'Percentage' ? ' %' : ' ₹'}' : '₹ 0'})',
                                              value:
                                              '- ₹ ${formatPrice(couponDiscount)}'),
                                          _summeryText(context,
                                              label: 'Service GST (${service.gst}%)',
                                              value: '+ ₹ ${formatPrice(gstAmount)}'),
                                          _summeryText(context,
                                              label:
                                              'Platform Fee (₹ ${formatPrice(platformFee)})',
                                              value:
                                              '+ ₹ ${formatPrice(platformFee)}'),
                                          _summeryText(context,
                                              label:
                                              'Fetch True Assurity Charge (${formatPrice(assurityFee)} %)',
                                              value:
                                              '+ ₹ ${formatPrice(assurityCharge)}'),
                                          Divider(height: 0),
                                          _summeryText(context,
                                              label: 'Grand Total',
                                              value: '₹ ${formatPrice(grandTotal)}'),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Column(
                              children: [
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
                                5.height,
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: CustomButton(
                                    isLoading: false,
                                    onPressed: () async {
                                      if (customerId == null) {
                                        showCustomToast('Please select customer.');
                                        return;
                                      }

                                      if (!_isAgree) {
                                        showCustomToast('Please agree to the terms & conditions.');
                                        return;
                                      }


                                      final discountAmount = price - discountedPrice;
                                      /// Model
                                      final checkoutData = CheckOutModel(
                                        user: userSession.userId.toString(),
                                        service: service.id.toString(),
                                        serviceCustomer: customer_Id.toString(),
                                        provider: widget.status == "default" ? null : widget.providerId,
                                        coupon: selectedCoupon?.id,
                                        subtotal: discountedPrice,
                                        serviceDiscount: discountPercent,
                                        couponDiscount: (selectedCoupon?.amount ?? 0).toDouble(),
                                        gst: (service.gst ?? 0).toDouble(),
                                        platformFee: platformFee.toDouble(),
                                        platformFeePrice: platformFee.toDouble(),
                                        champaignDiscount: 0,
                                        commission: commissionPrice.toString(),
                                        assurityfee: assurityFee,
                                        totalAmount: grandTotal,
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
                                        listingPrice: price,
                                        serviceDiscountPrice: discountAmount,
                                        priceAfterDiscount: discountedPrice,
                                        couponDiscountPrice: couponDiscount,
                                        serviceGSTPrice: gstAmount,
                                        assurityChargesPrice: assurityCharge,
                                      );
                                      widget.onPaymentDone(checkoutData);
                                    },
                                    label: 'Proceed',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else if (providerState is ProviderError) {
                  return Center(child: Text(providerState.message));
                }
                return const SizedBox.shrink();
              },
            );
          } else if (serviceState is ModuleServiceError) {
            return Center(child: Text(serviceState.errorMessage));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

Widget _summeryText(BuildContext context, {String? label, String? value}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label ?? ''),
      Text(value ?? ''),
    ],
  );
}
