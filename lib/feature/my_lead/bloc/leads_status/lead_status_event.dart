abstract class LeadStatusEvent {}

class FetchLeadStatus extends LeadStatusEvent {
  final String checkoutId;

  FetchLeadStatus(this.checkoutId);
}
