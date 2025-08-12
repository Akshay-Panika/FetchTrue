
import '../../model/commission_model.dart';

abstract class CommissionState {}

class CommissionInitial extends CommissionState {}

class CommissionLoading extends CommissionState {}

class CommissionLoaded extends CommissionState {
  final CommissionModel commission;
  CommissionLoaded(this.commission);
}

class CommissionError extends CommissionState {
  final String message;
  CommissionError(this.message);
}
