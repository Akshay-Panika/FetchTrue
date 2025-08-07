abstract class UserByIdEvent {}

class GetUserById extends UserByIdEvent {
  final String userId;
  GetUserById(this.userId);
}
