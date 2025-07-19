abstract class NonGpEvent {}

class FetchNonGpLeads extends NonGpEvent {
  final String userId;

  FetchNonGpLeads(this.userId);
}
