import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fetchtrue/feature/home/model/module_model.dart';
import '../../repository/module_service.dart';
import 'module_event.dart';
import 'module_state.dart';

class ModuleBloc extends Bloc<ModuleEvent, ModuleState> {
  final ModuleService moduleService;

  ModuleBloc(this.moduleService) : super(ModuleInitial()) {
    on<GetModule>((event, emit) async {
      emit(ModuleLoading());
      try {
        final modules = await moduleService.fetchModules();
        emit(ModuleLoaded(modules));
      } catch (e) {
        emit(ModuleError(e.toString()));
      }
    });
  }
}
