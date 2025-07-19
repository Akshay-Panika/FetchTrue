import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/favorite_services_model.dart';
import '../repository/favorite_service.dart';
import 'favorite_service_event.dart';
import 'favorite_service_state.dart';

class FavoriteServiceBloc extends Bloc<FavoriteServiceEvent, FavoriteServiceState> {
  FavoriteServiceBloc() : super(FavoriteServiceInitial()) {
    on<LoadFavoriteServices>(_onLoadFavorites);
    on<ToggleFavoriteService>(_onToggleFavorite);
  }

  Future<void> _onLoadFavorites(
      LoadFavoriteServices event, Emitter<FavoriteServiceState> emit) async {
    emit(FavoriteServiceLoading());
    try {
      final result = await fetchFavoriteServices(event.userId);
      if (result != null) {
        emit(FavoriteServiceLoaded(favoriteIds: result.favoriteServices));
      } else {
        emit(FavoriteServiceError("Failed to load favorite services."));
      }
    } catch (e) {
      emit(FavoriteServiceError("Something went wrong: $e"));
    }
  }

  void _onToggleFavorite(
      ToggleFavoriteService event, Emitter<FavoriteServiceState> emit) {
    if (state is FavoriteServiceLoaded) {
      final currentState = state as FavoriteServiceLoaded;
      final currentFavorites = List<String>.from(currentState.favoriteIds);

      if (currentFavorites.contains(event.serviceId)) {
        currentFavorites.remove(event.serviceId);
      } else {
        currentFavorites.add(event.serviceId);
      }

      emit(FavoriteServiceLoaded(favoriteIds: currentFavorites));
    }
  }
}
