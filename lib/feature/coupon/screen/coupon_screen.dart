import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:bizbooster2x/core/costants/text_style.dart';
import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';
import 'package:bizbooster2x/feature/coupon/bloc/coupon/coupon_bloc.dart';
import 'package:bizbooster2x/feature/coupon/bloc/coupon/coupon_event.dart';
import 'package:bizbooster2x/feature/coupon/repository/coupon_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/coupon/coupon_state.dart';
import '../model/coupon_model.dart';

class CouponScreen extends StatelessWidget {
  const CouponScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Coupons', showBackButton: true),
      body: BlocProvider(
        create: (_) => CouponBloc(CouponService())..add(GetCoupon()),
        child: BlocBuilder<CouponBloc, CouponState>(
          builder: (context, state) {
            if (state is CouponLoading) {
              return const LinearProgressIndicator();
            } else if (state is CouponLoaded) {
              final coupon = state.couponModel;

              if (coupon.isEmpty) {
                return const Center(child: Text('No coupon found.'));
              }

              final appliedCoupon = coupon.first;

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    10.height,
                    _buildAppliedCouponCard(context, appliedCoupon),
                    10.height,
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text("Other Coupons", style: textStyle14(context)),
                    ),
                    Column(
                      children: coupon
                          .map((c) => _buildCouponCard(context, c))
                          .toList(),
                    ),
                  ],
                ),
              );
            } else if (state is CouponError) {
              return Center(child: Text(state.errorMessage));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildAppliedCouponCard(BuildContext context, CouponModel coupon) {
    String _formatDate(DateTime date) {
      return "${date.day}-${date.month}-${date.year}";
    }

    return CustomContainer(
      backgroundColor: CustomColor.whiteColor,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.check_box, color: Colors.red, size: 14),
              const SizedBox(width: 6),
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
                  Text(coupon.discountTitle, style: textStyle12(context)),
                  Text(
                    "You save an extra ₹${coupon.amount} with this coupon.",
                    style: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),
                  ),
                  Row(
                    children: [
                      CustomContainer(
                        border: true,
                        margin: EdgeInsets.zero,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        child: Text("#${coupon.couponCode}", style: textStyle12(context, color: CustomColor.greenColor)),
                      ),
                      CustomContainer(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        child: Text("Apply Coupon", style: textStyle12(context, color: CustomColor.appColor)),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Text("\u2022 ${coupon.discountType}"),
          Text("\u2022 Expires on : ${_formatDate(coupon.endDate)}"),
        ],
      ),
    );
  }

  Widget _buildCouponCard(BuildContext context, CouponModel coupon) {
    return CustomContainer(
      backgroundColor: CustomColor.whiteColor,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(coupon.discountTitle, style: textStyle12(context)),
          Text(
            "You save an extra ₹${coupon.amount} with this coupon.",
            style: textStyle12(context, fontWeight: FontWeight.w400, color: CustomColor.descriptionColor),
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
                child: Text("Apply Coupon", style: textStyle12(context, color: CustomColor.appColor)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
