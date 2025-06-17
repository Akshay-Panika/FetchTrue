

import '../../model/coupon_model.dart';

abstract class CouponState{}

class CouponInitial extends CouponState{}

class CouponLoading extends CouponState {}

class CouponLoaded extends CouponState {
  final List<CouponModel>  couponModel;
  final CouponModel? appliedCoupon;

  CouponLoaded(this.couponModel, {this.appliedCoupon});
}

class CouponError extends CouponState {
  final String errorMessage;
  CouponError(this.errorMessage);
}
