import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../model/coupon_model.dart';
import 'coupon_event.dart';
import 'coupon_state.dart';

class CouponBloc extends Bloc<CouponEvent, CouponState> {
  CouponBloc() : super(CouponInitial()) {
    on<FetchCouponsEvent>(_onFetchCoupons);
  }

  Future<void> _onFetchCoupons(FetchCouponsEvent event, Emitter<CouponState> emit) async {
    emit(CouponLoading());
    try {
      final response = await http.get(Uri.parse('https://biz-booster.vercel.app/api/coupon'));

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        if (body['success'] == true) {
          final List<CouponModel> coupons = (body['data'] as List)
              .map((json) => CouponModel.fromJson(json))
              .toList();
          emit(CouponLoaded(coupons));
        } else {
          emit(CouponError("Failed to fetch coupons"));
        }
      } else {
        emit(CouponError("Server error: ${response.statusCode}"));
      }
    } catch (e) {
      emit(CouponError("Exception: $e"));
    }
  }
}
