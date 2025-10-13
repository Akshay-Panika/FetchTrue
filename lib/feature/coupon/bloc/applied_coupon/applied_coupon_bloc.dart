import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/applied_coupon_repository.dart';
import 'applied_coupon_event.dart';
import 'applied_coupon_state.dart';

class AppliedCouponBloc extends Bloc<AppliedCouponEvent, AppliedCouponState> {
  final AppliedCouponRepository repository;

  AppliedCouponBloc({required this.repository}) : super(AppliedCouponInitial()) {
    on<FetchAppliedCoupons>((event, emit) async {
      emit(AppliedCouponLoading());
      try {
        final coupons = await repository.fetchCouponsByUser(event.userId);
        emit(AppliedCouponLoaded(coupons));
      } catch (e) {
        emit(AppliedCouponError(e.toString()));
      }
    });
  }
}
