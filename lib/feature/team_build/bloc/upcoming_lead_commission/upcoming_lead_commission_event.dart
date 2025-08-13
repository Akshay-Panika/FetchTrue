abstract class UpcomingLeadCommissionEvent {}

class FetchUpcomingLeadCommission extends UpcomingLeadCommissionEvent {
  final String checkoutId;
  FetchUpcomingLeadCommission(this.checkoutId);
}
