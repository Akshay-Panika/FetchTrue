import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/upcoming_lead_commission_repository.dart';
import 'upcoming_lead_commission_event.dart';
import 'upcoming_lead_commission_state.dart';

class UpcomingLeadCommissionBloc
    extends Bloc<UpcomingLeadCommissionEvent, UpcomingLeadCommissionState> {
  final UpcomingLeadCommissionRepository repository;

  UpcomingLeadCommissionBloc({required this.repository})
      : super(UpcomingLeadCommissionInitial()) {
    on<FetchUpcomingLeadCommission>((event, emit) async {
      emit(UpcomingLeadCommissionLoading());
      try {
        final data = await repository.fetchCommission(event.checkoutId);
        emit(UpcomingLeadCommissionLoaded(data));
      } catch (e) {
        emit(UpcomingLeadCommissionError(e.toString()));
      }
    });
  }
}
