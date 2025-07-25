abstract class LeadsEvent {}

class FetchLeadsDataById extends LeadsEvent {
  final String userId;

  FetchLeadsDataById(this.userId);
}
