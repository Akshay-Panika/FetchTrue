import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../bloc/coupon/coupon_bloc.dart';
import '../bloc/coupon/coupon_event.dart';
import '../bloc/coupon/coupon_state.dart';
import '../bloc/applied_coupon/applied_coupon_bloc.dart';
import '../bloc/applied_coupon/applied_coupon_event.dart';
import '../bloc/applied_coupon/applied_coupon_state.dart';
import '../repository/applied_coupon_repository.dart';
import '../model/coupon_model.dart';
import '../model/applied_coupon_model.dart';

class CouponScreen extends StatefulWidget {
  const CouponScreen({super.key});

  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {
  CouponModel? appliedCoupon;

  @override
  Widget build(BuildContext context) {
    final userSession = Provider.of<UserSession>(context);
    final userId = userSession.userId ?? "";

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, appliedCoupon);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Coupons'),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context, appliedCoupon);
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        body: SafeArea(
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => CouponBloc()..add(FetchCouponsEvent())),
              BlocProvider(
                create: (_) => AppliedCouponBloc(
                  repository: AppliedCouponRepository(),
                )..add(FetchAppliedCoupons(userId: userId)),
              ),
            ],
            child: BlocBuilder<CouponBloc, CouponState>(
              builder: (context, couponState) {
                if (couponState is CouponLoading) {
                  return LinearProgressIndicator(
                    minHeight: 2.5,
                    backgroundColor: CustomColor.appColor,
                    color: CustomColor.whiteColor,
                  );
                } else if (couponState is CouponLoaded) {
                  final coupons = couponState.coupons;

                  if (coupons.isEmpty) {
                    return const Center(child: Text("No coupons found."));
                  }

                  // Listen applied coupons bloc
                  return BlocBuilder<AppliedCouponBloc, AppliedCouponState>(
                    builder: (context, appliedState) {
                      List<AppliedCoupon> appliedCoupons = [];
                      if (appliedState is AppliedCouponLoaded) {
                        appliedCoupons = appliedState.coupons;
                      }

                      return SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            20.height,
                            Column(
                              children: List.generate(
                                coupons.length,
                                    (index) => _buildCouponCard(
                                  context,
                                  coupons[index],
                                  appliedCoupons,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else if (couponState is CouponError) {
                  return Center(child: Text(couponState.message));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCouponCard(
      BuildContext context,
      CouponModel coupon,
      List<AppliedCoupon> appliedCoupons,
      ) {
    final isPercentage = coupon.discountAmountType == 'Percentage';

    // check if this coupon is already applied by matching IDs
    final isAlreadyApplied = appliedCoupons.any(
          (applied) => applied.couponId == coupon.id,
    );

    final isCurrentlySelected = appliedCoupon?.couponCode == coupon.couponCode;

    final isApplied = isAlreadyApplied || isCurrentlySelected;

    return CustomContainer(
      color: CustomColor.whiteColor,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(coupon.discountTitle, style: textStyle14(context)),
          Text(
            "You save an extra ${isPercentage ? '${coupon.amount}%' : '₹${coupon.amount}'} with this coupon.",
            style: textStyle14(
              context,
              fontWeight: FontWeight.w400,
              color: CustomColor.descriptionColor,
            ),
          ),
          10.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomContainer(
                border: true,
                margin: EdgeInsets.zero,
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Text(
                  "#${coupon.couponCode}",
                  style: textStyle12(context, color: CustomColor.greenColor),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    if (isApplied) {
                      appliedCoupon = null; // deselect
                    } else {
                      appliedCoupon = coupon; // select
                    }
                  });
                },
                child: CustomContainer(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Text(
                    isApplied ? "Applied Coupon" : "Apply Coupon",
                    style: textStyle12(
                      context,
                      color: isApplied
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
}
