import '../../model/lead_status_model.dart';

abstract class LeadStatusState {}

class LeadStatusInitial extends LeadStatusState {}

class LeadStatusLoading extends LeadStatusState {}

class LeadStatusLoaded extends LeadStatusState {
  final LeadStatusModel leadStatus;

  LeadStatusLoaded(this.leadStatus);
}

class LeadStatusError extends LeadStatusState {
  final String message;

  LeadStatusError(this.message);
}
