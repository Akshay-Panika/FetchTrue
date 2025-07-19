abstract class FavoriteServiceEvent {}

class LoadFavoriteServices extends FavoriteServiceEvent {
  final String userId;
  LoadFavoriteServices(this.userId);
}

class ToggleFavoriteService extends FavoriteServiceEvent {
  final String serviceId;
  ToggleFavoriteService(this.serviceId);
}
