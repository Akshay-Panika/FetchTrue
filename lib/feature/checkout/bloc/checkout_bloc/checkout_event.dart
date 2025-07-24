import '../../model/checkout_model.dart';

abstract class CheckoutEvent {}

class SubmitCheckoutEvent extends CheckoutEvent {
  final CheckOutModel model;

  SubmitCheckoutEvent(this.model);
}
