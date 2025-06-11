

import '../../model/coupon_model.dart';

abstract class CouponEvent {}

class GetCoupon extends CouponEvent {}

class ApplyCoupon extends CouponEvent {
  final CouponModel coupon;
  ApplyCoupon(this.coupon);
}
