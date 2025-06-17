

import '../../model/lead_model.dart';

abstract class LeadState{}

class LeadInitial extends LeadState{}

class LeadLoading extends LeadState {}

class LeadLoaded extends LeadState {
  final List<LeadModel>  leadModel;
  LeadLoaded(this.leadModel);
}

class ModuleError extends LeadState {
  final String errorMessage;
  ModuleError(this.errorMessage);
}
