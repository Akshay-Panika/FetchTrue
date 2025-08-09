// my_team_state.dart
import '../../model/my_team_model.dart';

abstract class MyTeamState {}

class MyTeamInitial extends MyTeamState {}

class MyTeamLoading extends MyTeamState {}

class MyTeamLoaded extends MyTeamState {
  final MyTeamModel myTeam;

  MyTeamLoaded(this.myTeam);
}

class MyTeamError extends MyTeamState {
  final String message;

  MyTeamError(this.message);
}
