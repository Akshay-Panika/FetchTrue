abstract class UserEvent {}

class FetchUserById extends UserEvent {
  final String userId;
  FetchUserById(this.userId);
}

class UserReset extends UserEvent {} 
