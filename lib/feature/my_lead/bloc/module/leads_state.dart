
import '../../model/leads_model.dart';

abstract class LeadsState {}

class CheckoutInitial extends LeadsState {}

class CheckoutLoading extends LeadsState {}

class CheckoutLoaded extends LeadsState {
  final List<LeadsModel> checkouts;

  CheckoutLoaded(this.checkouts);
}

class CheckoutError extends LeadsState {
  final String message;

  CheckoutError(this.message);
}
