import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../model/leads_model.dart';
import 'leads_event.dart';
import 'leads_state.dart';

class LeadsBloc extends Bloc<LeadsEvent, LeadsState> {
  LeadsBloc() : super(LeadsInitial()) {
    on<FetchLeadsDataById>((event, emit) async {
      emit(LeadsLoading());

      try {
        final url = 'https://biz-booster.vercel.app/api/checkout/lead-by-user/${event.userId}';
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final body = json.decode(response.body);
          final List data = body['data'];
          final checkouts = data.map((e) => LeadsModel.fromJson(e)).toList();
          emit(LeadsLoaded(checkouts.cast<LeadsModel>()));
        } else {
          emit(LeadsError('Error: ${response.statusCode}'));
        }
      } catch (e) {
        emit(LeadsError(e.toString()));
      }
    });
  }
}
