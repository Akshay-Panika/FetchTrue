
import 'package:fetchtrue/feature/home/model/module_model.dart';

abstract class ModuleState{}

class ModuleInitial extends ModuleState{}

class ModuleLoading extends ModuleState {}

class ModuleLoaded extends ModuleState {
  final List<ModuleModel>  moduleModel;
  ModuleLoaded(this.moduleModel);
}

class ModuleError extends ModuleState {
  final String errorMessage;
  ModuleError(this.errorMessage);
}
