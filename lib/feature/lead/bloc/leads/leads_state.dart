
import '../../model/leads_model.dart';

abstract class LeadsState {}

class LeadsInitial extends LeadsState {}

class LeadsLoading extends LeadsState {}

class LeadsLoaded extends LeadsState {
  final List<LeadsModel> checkouts;

  LeadsLoaded(this.checkouts);
}

class LeadsError extends LeadsState {
  final String message;

  LeadsError(this.message);
}
