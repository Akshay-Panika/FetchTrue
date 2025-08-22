import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';
import '../bloc/coupon/coupon_bloc.dart';
import '../bloc/coupon/coupon_event.dart';
import '../bloc/coupon/coupon_state.dart';
import '../model/coupon_model.dart';

class CouponScreen extends StatefulWidget {
  const CouponScreen({super.key});

  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {
  CouponModel? appliedCoupon;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, appliedCoupon);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Coupons'),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context, appliedCoupon);
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
        ),

        body: SafeArea(
          child: BlocProvider(
            create: (context) => CouponBloc()..add(FetchCouponsEvent()),
            child: BlocBuilder<CouponBloc, CouponState>(
              builder: (context, state) {
                if (state is CouponLoading) {
                  return LinearProgressIndicator(
                    backgroundColor: CustomColor.appColor,
                    color: CustomColor.whiteColor,
                    minHeight: 2.5,
                  );
                } else if (state is CouponLoaded) {
                  final coupons = state.coupons;

                  if (coupons.isEmpty) {
                    return const Center(child: Text("No coupons found."));
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        20.height,
                        if (appliedCoupon != null) ...[
                          Text("Applied Coupon", style: textStyle14(context, color: CustomColor.descriptionColor)),
                          _buildCouponAppliedCard(context, appliedCoupon!),
                          20.height,
                        ],
                        Text("Available Coupons", style: textStyle14(context, color: CustomColor.descriptionColor)),
                        Column(
                          children: List.generate(
                            coupons.length,
                                (index) => _buildCouponCard(context, coupons[index]),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (state is CouponError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildCouponCard(BuildContext context, CouponModel coupon) {
    final isPercentage = coupon.discountAmountType == 'Percentage';

    return CustomContainer(
      color: CustomColor.whiteColor,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(coupon.discountTitle, style: textStyle14(context)),
          Text(
            "You save an extra ${isPercentage ? '${coupon.amount}%' : '₹${coupon.amount}'} with this coupon.",
            style: textStyle14(context, fontWeight: FontWeight.w400, color: CustomColor.descriptionColor),
          ),
          10.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomContainer(
                border: true,
                margin: EdgeInsets.zero,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Text("#${coupon.couponCode}", style: textStyle12(context, color: CustomColor.greenColor)),
              ),

              InkWell(
                onTap: () {
                  setState(() {
                    appliedCoupon = coupon;
                    // Navigator.pop(context, coupon);
                  });
                },
                child: CustomContainer(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Text(
                    appliedCoupon == coupon ? "Applied" : "Apply Coupon",
                    style: textStyle12(
                      context,
                      color: appliedCoupon == coupon
                          ? CustomColor.appColor
                          : CustomColor.descriptionColor,
                    ),
                  ),
                ),
              ),

            ],
          ),
        ],
      ),
    );
  }

  /// ✅ Applied Coupon Card
  Widget _buildCouponAppliedCard(BuildContext context, CouponModel coupon) {
    final isPercentage = coupon.discountAmountType == 'Percentage';

    return CustomContainer(
      color: CustomColor.whiteColor,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(coupon.discountTitle, style: textStyle14(context)),
          Text(
            "You save an extra ${isPercentage ? '${coupon.amount}%' : '₹${coupon.amount}'} with this coupon.",
            style: textStyle14(context, fontWeight: FontWeight.w400, color: CustomColor.descriptionColor),
          ),
          10.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomContainer(
                border: true,
                margin: EdgeInsets.zero,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Text("#${coupon.couponCode}", style: textStyle12(context, color: CustomColor.greenColor)),
              ),
              CustomContainer(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Text("Applied Coupon", style: textStyle12(context, color: CustomColor.descriptionColor)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
