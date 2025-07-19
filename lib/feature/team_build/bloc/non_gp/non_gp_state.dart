import '../../model/non_gp_model.dart';

abstract class NonGpState {}

class NonGpInitial extends NonGpState {}

class NonGpLoading extends NonGpState {}

class NonGpLoaded extends NonGpState {
  final List<NonGpModel> leads;

  NonGpLoaded(this.leads);

  int get totalCount => leads.length;
}

class NonGpError extends NonGpState {
  final String message;

  NonGpError(this.message);
}
