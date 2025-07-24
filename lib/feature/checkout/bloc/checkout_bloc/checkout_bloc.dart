import 'package:flutter_bloc/flutter_bloc.dart';
import 'checkout_event.dart';
import 'checkout_state.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  CheckoutBloc() : super(CheckoutInitial()) {
    on<SubmitCheckoutEvent>(_onSubmitCheckout);
  }

  Future<void> _onSubmitCheckout(
      SubmitCheckoutEvent event,
      Emitter<CheckoutState> emit,
      ) async {
    emit(CheckoutLoading());

    try {
      final response = await http.post(
        Uri.parse('https://biz-booster.vercel.app/api/checkout'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(event.model.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(CheckoutSuccess());
      } else {
        final body = jsonDecode(response.body);
        emit(CheckoutFailure(body['message'] ?? 'Failed to checkout'));
      }
    } catch (e) {
      emit(CheckoutFailure(e.toString()));
    }
  }
}
