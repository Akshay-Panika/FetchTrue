import '../../model/upcoming_lead_commission_model.dart';

abstract class UpcomingLeadCommissionState {}

class UpcomingLeadCommissionInitial extends UpcomingLeadCommissionState {}

class UpcomingLeadCommissionLoading extends UpcomingLeadCommissionState {}

class UpcomingLeadCommissionLoaded extends UpcomingLeadCommissionState {
  final UpcomingLeadCommissionModel commission;
  UpcomingLeadCommissionLoaded(this.commission);
}

class UpcomingLeadCommissionError extends UpcomingLeadCommissionState {
  final String message;
  UpcomingLeadCommissionError(this.message);
}
