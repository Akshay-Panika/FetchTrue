import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/favorite_service_repository.dart';
import 'favorite_service_event.dart';
import 'favorite_service_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FavoriteRepository repository;

  FavoriteBloc(this.repository) : super(FavoriteInitial()) {
    // Add to favorite
    on<AddFavoriteEvent>((event, emit) async {
      emit(FavoriteLoading());
      try {
        final response = await repository.addToFavorite(event.userId, event.serviceId);
        emit(FavoriteSuccess(response.message));
      } catch (e) {
        emit(FavoriteFailure(e.toString()));
      }
    });

    // Remove from favorite
    on<RemoveFavoriteEvent>((event, emit) async {
      emit(FavoriteLoading());
      try {
        final response = await repository.removeFromFavorite(event.userId, event.serviceId);
        emit(FavoriteSuccess(response.message));
      } catch (e) {
        emit(FavoriteFailure(e.toString()));
      }
    });
  }
}
