import 'package:bizbooster2x/feature/coupon/repository/coupon_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'coupon_event.dart';
import 'coupon_state.dart';

class CouponBloc extends Bloc<CouponEvent, CouponState> {
  final CouponService couponService;

  CouponBloc(this.couponService) : super(CouponInitial()) {
    on<GetCoupon>((event, emit) async {
      emit(CouponLoading());
      try {
        final coupon = await couponService.fetchCoupon();
        emit(CouponLoaded(coupon));
      } catch (e) {
        emit(CouponError(e.toString()));
      }
    });

    on<ApplyCoupon>((event, emit) {
      if (state is CouponLoaded) {
        final current = state as CouponLoaded;
        emit(CouponLoaded(current.couponModel, appliedCoupon: event.coupon));
      }
    });
  }
}
