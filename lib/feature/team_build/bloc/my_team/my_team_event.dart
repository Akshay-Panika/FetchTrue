// my_team_event.dart
abstract class MyTeamEvent {}

class GetMyTeam extends MyTeamEvent {
  final String userId;

  GetMyTeam(this.userId);
}
