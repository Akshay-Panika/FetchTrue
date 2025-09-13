import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/lead_repository.dart';
import 'lead_event.dart';
import 'lead_state.dart';

class LeadBloc extends Bloc<LeadEvent, LeadState> {
  final LeadRepository repository;

  LeadBloc(this.repository) : super(LeadInitial()) {
    on<FetchLeadsByUser>((event, emit) async {
      emit(LeadLoading());
      try {
        final result = await repository.getLead(event.userId);
        if (result != null) {
          emit(LeadLoaded(result));
        } else {
          emit(LeadError("Failed to fetch leads"));
        }
      } catch (e) {
        emit(LeadError(e.toString()));
      }
    });
    on<ClearLeadData>((event, emit) {
      emit(LeadInitial());
    });
  }
}
