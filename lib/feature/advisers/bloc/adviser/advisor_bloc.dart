import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fetchtrue/feature/advisers/model/advisor_model.dart';
import '../../repojetory/advisor_repository.dart';
import 'advisor_event.dart';
import 'advisor_state.dart';

class AdvisorBloc extends Bloc<AdvisorEvent, AdvisorState> {
  final AdvisorRepository repository;

  AdvisorBloc({required this.repository}) : super(AdvisorInitial()) {
    on<FetchAdvisors>(_onFetchAdvisors);
  }

  Future<void> _onFetchAdvisors(
      FetchAdvisors event, Emitter<AdvisorState> emit) async {
    try {
      emit(AdvisorLoading());
      final List<AdvisorModel> advisors = await repository.fetchAdvisors();
      if (advisors.isEmpty) {
        emit(const AdvisorEmpty());
      } else {
        emit(AdvisorLoaded(advisors));
      }
    } catch (e) {
      emit(AdvisorError(e.toString()));
    }
  }
}
