import '../../ads/model/add_model.dart';

abstract class AdsState {}

class AdsInitial extends AdsState {}

class AdsLoading extends AdsState {}

class AdsLoaded extends AdsState {
  final AdsModel ads;

  AdsLoaded(this.ads);
}

class AdsError extends AdsState {
  final String message;

  AdsError(this.message);
}
