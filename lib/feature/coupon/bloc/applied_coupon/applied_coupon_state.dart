import 'package:equatable/equatable.dart';

import '../../model/applied_coupon_model.dart';

abstract class AppliedCouponState extends Equatable {
  const AppliedCouponState();

  @override
  List<Object?> get props => [];
}

class AppliedCouponInitial extends AppliedCouponState {}

class AppliedCouponLoading extends AppliedCouponState {}

class AppliedCouponLoaded extends AppliedCouponState {
  final List<AppliedCoupon> coupons;

  const AppliedCouponLoaded(this.coupons);

  @override
  List<Object?> get props => [coupons];
}

class AppliedCouponError extends AppliedCouponState {
  final String message;

  const AppliedCouponError(this.message);

  @override
  List<Object?> get props => [message];
}
