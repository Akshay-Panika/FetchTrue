


import '../../model/module_subcategory_model.dart';

abstract class ModuleSubcategoryState{}

class ModuleSubcategoryInitial extends ModuleSubcategoryState{}

class ModuleSubcategoryLoading extends ModuleSubcategoryState {}

class ModuleSubcategoryLoaded extends ModuleSubcategoryState {
  final List<ModuleSubCategoryModel>  moduleSubcategoryModel;
  ModuleSubcategoryLoaded(this.moduleSubcategoryModel);
}

class ModuleCategoryError extends ModuleSubcategoryState {
  final String errorMessage;
  ModuleCategoryError(this.errorMessage);
}
