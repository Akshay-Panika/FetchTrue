import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/lead_service.dart';
import 'lead_event.dart';
import 'lead_state.dart';


class LeadBloc extends Bloc<LeadEvent, LeadState> {
  final LeadService leadService;

  LeadBloc(this.leadService) : super(LeadInitial()) {
    on<GetLead>((event, emit) async {
      emit(LeadLoading());
      try {
        final modules = await leadService.fetchLeads();
        emit(LeadLoaded(modules));
      } catch (e) {
        emit(LeadError(e.toString()));
      }
    });
  }
}
