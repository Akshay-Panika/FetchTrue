import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/non_gp_service.dart';
import 'non_gp_event.dart';
import 'non_gp_state.dart';

class NonGpBloc extends Bloc<NonGpEvent, NonGpState> {
  final NonGpService service;

  NonGpBloc(this.service) : super(NonGpInitial()) {
    on<FetchNonGpLeads>((event, emit) async {
      emit(NonGpLoading());
      try {
        final leads = await service.fetchMyLeads(event.userId);
        emit(NonGpLoaded(leads));
      } catch (e) {
        emit(NonGpError('Failed to fetch leads: $e'));
      }
    });
  }
}
