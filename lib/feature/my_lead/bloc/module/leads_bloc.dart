import 'package:fetchtrue/feature/my_lead/bloc/module/leads_event.dart';
import 'package:fetchtrue/feature/my_lead/bloc/module/leads_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../model/leads_model.dart';

class LeadsBloc extends Bloc<LeadsEvent, LeadsState> {
  LeadsBloc() : super(CheckoutInitial()) {
    on<FetchLeadsDataById>((event, emit) async {
      emit(CheckoutLoading());

      try {
        final url = 'https://biz-booster.vercel.app/api/checkout/lead-by-user/${event.userId}';
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final body = json.decode(response.body);
          final List data = body['data'];
          final checkouts = data.map((e) => LeadsModel.fromJson(e)).toList();
          emit(CheckoutLoaded(checkouts.cast<LeadsModel>()));
        } else {
          emit(CheckoutError('Error: ${response.statusCode}'));
        }
      } catch (e) {
        emit(CheckoutError(e.toString()));
      }
    });
  }
}
