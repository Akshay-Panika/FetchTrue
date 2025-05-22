

import '../../model/module_category_model.dart';

abstract class ModuleCategoryState{}

class ModuleCategoryInitial extends ModuleCategoryState{}

class ModuleCategoryLoading extends ModuleCategoryState {}

class ModuleCategoryLoaded extends ModuleCategoryState {
  final List<ModuleCategoryModel>  moduleCategoryModel;
  ModuleCategoryLoaded(this.moduleCategoryModel);
}

class ModuleCategoryError extends ModuleCategoryState {
  final String errorMessage;
  ModuleCategoryError(this.errorMessage);
}
