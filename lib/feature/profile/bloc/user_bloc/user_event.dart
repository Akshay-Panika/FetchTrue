// abstract class UserEvent {}
//
// class FetchUserById extends UserEvent {
//   final String userId;
//   FetchUserById(this.userId);
// }
//
// class UserReset extends UserEvent {}
//
// class UserFavoriteChangedEvent extends UserEvent {
//   final String serviceId;
//   final bool isFavorite;
//
//   UserFavoriteChangedEvent({required this.serviceId, required this.isFavorite});
// }
//

abstract class UserEvent {}

class FetchUserById extends UserEvent {
  final String userId;
  FetchUserById(this.userId);
}

class UserReset extends UserEvent {}

class UserFavoriteChangedEvent extends UserEvent {
  final String serviceId;
  final bool isFavorite;

  UserFavoriteChangedEvent({required this.serviceId, required this.isFavorite});
}

class UserFavoriteProviderChangedEvent extends UserEvent {
  final String providerId;
  final bool isFavorite;

  UserFavoriteProviderChangedEvent({required this.providerId, required this.isFavorite});
}
