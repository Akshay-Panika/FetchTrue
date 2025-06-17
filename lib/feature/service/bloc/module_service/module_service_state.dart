
import '../../model/service_model.dart';

abstract class ModuleServiceState{}

class ModuleServiceInitial extends ModuleServiceState{}

class ModuleServiceLoading extends ModuleServiceState {}

class ModuleServiceLoaded extends ModuleServiceState {
  final List<ServiceModel>  serviceModel;
  ModuleServiceLoaded(this.serviceModel);
}

class ModuleServiceError extends ModuleServiceState {
  final String errorMessage;
  ModuleServiceError(this.errorMessage);
}
