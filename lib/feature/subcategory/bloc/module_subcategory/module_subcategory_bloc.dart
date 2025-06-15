import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/module_subcategory_service.dart';
import 'module_subcategory_event.dart';
import 'module_subcategory_state.dart';

class ModuleSubcategoryBloc extends Bloc<ModuleSubcategoryEvent, ModuleSubcategoryState> {
  final SubCategoryService subCategoryService;

  ModuleSubcategoryBloc(this.subCategoryService) : super(ModuleSubcategoryInitial()) {
    on<GetModuleSubcategory>((event, emit) async {
      emit(ModuleSubcategoryLoading());
      try {
        final moduleSubcategory = await subCategoryService.fetchSubCategory();
        emit(ModuleSubcategoryLoaded(moduleSubcategory));
      } catch (e) {
        emit(ModuleCategoryError(e.toString()));
      }
    });
  }
}
