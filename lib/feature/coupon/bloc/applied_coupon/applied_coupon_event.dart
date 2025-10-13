import 'package:equatable/equatable.dart';

abstract class AppliedCouponEvent extends Equatable {
  const AppliedCouponEvent();

  @override
  List<Object?> get props => [];
}

class FetchAppliedCoupons extends AppliedCouponEvent {
  final String userId;

  const FetchAppliedCoupons({required this.userId});

  @override
  List<Object?> get props => [userId];
}
