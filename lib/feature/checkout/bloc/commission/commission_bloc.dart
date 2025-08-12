import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/commission_service.dart';
import 'commission_event.dart';
import 'commission_state.dart';

class CommissionBloc extends Bloc<CommissionEvent, CommissionState> {
  CommissionBloc() : super(CommissionInitial()) {
    on<GetCommissionEvent>((event, emit) async {
      emit(CommissionLoading());
      try {
        final data = await CommissionService.fetchCommission();
        if (data != null) {
          emit(CommissionLoaded(data));
        } else {
          emit(CommissionError('No commission data found'));
        }
      } catch (e) {
        emit(CommissionError(e.toString()));
      }
    });
  }
}
