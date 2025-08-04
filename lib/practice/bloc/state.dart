import '../model.dart';

abstract class UState {}

class UInitial extends UState {}

class ULoading extends UState {}

class ULoaded extends UState {
  final UModel user;
  ULoaded(this.user);
}

class UError extends UState {
  final String message;
  UError(this.message);
}
