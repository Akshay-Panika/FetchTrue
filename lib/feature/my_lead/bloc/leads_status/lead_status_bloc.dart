import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/lead_status_model.dart';
import 'lead_status_event.dart';
import 'lead_status_state.dart';
import 'package:http/http.dart' as http;

class LeadStatusBloc extends Bloc<LeadStatusEvent, LeadStatusState> {
  LeadStatusBloc() : super(LeadStatusInitial()) {
    on<FetchLeadStatus>(_onFetchLeadStatus);
  }

  Future<void> _onFetchLeadStatus(
      FetchLeadStatus event, Emitter<LeadStatusState> emit) async {
    emit(LeadStatusLoading());

    try {
      final response = await http.get(Uri.parse(
          'https://biz-booster.vercel.app/api/leads/FindByCheckout/${event.checkoutId}'));

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        final leadStatus = LeadStatusModel.fromJson(body['data']);
        emit(LeadStatusLoaded(leadStatus));
      } else {
        emit(LeadStatusError('Failed to fetch data'));
      }
    } catch (e) {
      emit(LeadStatusError('Error: ${e.toString()}'));
    }
  }
}
