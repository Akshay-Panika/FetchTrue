import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/gallery_repository.dart';
import 'gallery_event.dart';
import 'gallery_state.dart';

class GalleryBloc extends Bloc<GalleryEvent, GalleryState> {
  final GalleryRepository repository;

  GalleryBloc(this.repository) : super(GalleryInitial()) {
    on<LoadGallery>((event, emit) async {
      emit(GalleryLoading());
      try {
        final gallery = await repository.fetchGallery(event.providerId);
        emit(GalleryLoaded(gallery));
      } catch (e) {
        emit(GalleryError(e.toString()));
      }
    });
  }
}
