abstract class FavoriteServiceState {}

class FavoriteServiceInitial extends FavoriteServiceState {}

class FavoriteServiceLoading extends FavoriteServiceState {}

class FavoriteServiceLoaded extends FavoriteServiceState {
  final List<String> favoriteIds;
  FavoriteServiceLoaded({required this.favoriteIds});
}

class FavoriteServiceError extends FavoriteServiceState {
  final String message;
  FavoriteServiceError(this.message);
}
