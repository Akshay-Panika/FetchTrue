import '../../model/youtube_short_model.dart';

abstract class ShortsState {}
class ShortsLoading extends ShortsState {}
class ShortsLoaded extends ShortsState {
  final List<YouTubeShortModel> shorts;
  ShortsLoaded(this.shorts);
}
class ShortsError extends ShortsState {
  final String message;
  ShortsError(this.message);
}