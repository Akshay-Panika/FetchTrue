import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../helper/api_helper.dart';
import '../../repository/module_category_service.dart';
import 'module_category_event.dart';
import 'module_category_state.dart';

class ModuleCategoryBloc extends Bloc<ModuleCategoryEvent, ModuleCategoryState> {
  final ModuleCategoryService moduleCategoryService;

  ModuleCategoryBloc(this.moduleCategoryService) : super(ModuleCategoryInitial()) {
    on<GetModuleCategory>((event, emit) async {
      emit(ModuleCategoryLoading());
      try {
        final moduleCategory = await moduleCategoryService.fetchModuleCategory();
        emit(ModuleCategoryLoaded(moduleCategory));
      } catch (e) {
        emit(ModuleCategoryError(e.toString()));
      }
    });
  }
}
