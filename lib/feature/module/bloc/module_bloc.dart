import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/module_repository.dart';
import 'module_event.dart';
import 'module_state.dart';

class ModuleBloc extends Bloc<ModuleEvent, ModuleState> {
  final ModuleRepository repository;

  ModuleBloc(this.repository) : super(ModuleInitial()) {
    on<FetchModules>((event, emit) async {
      emit(ModuleLoading());
      try {
        final modules = await repository.fetchModules();
        emit(ModuleLoaded(modules));
      } catch (e) {
        emit(ModuleError(e.toString()));
      }
    });
  }
}
