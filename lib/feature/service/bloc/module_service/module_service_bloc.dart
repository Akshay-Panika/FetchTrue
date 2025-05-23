import 'package:bizbooster2x/feature/service/repository/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'module_service_event.dart';
import 'module_service_state.dart';

class ModuleServiceBloc extends Bloc<ModuleServiceEvent, ModuleServiceState> {
  final ApiService apiService;

  ModuleServiceBloc(this.apiService) : super(ModuleServiceInitial()) {
    on<GetModuleService>((event, emit) async {
      emit(ModuleServiceLoading());
      try {
        final moduleService = await apiService.fetchServices();
        emit(ModuleServiceLoaded(moduleService));
      } catch (e) {
        emit(ModuleServiceError(e.toString()));
      }
    });
  }
}
