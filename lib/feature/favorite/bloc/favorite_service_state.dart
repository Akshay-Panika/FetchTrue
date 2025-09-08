import 'package:equatable/equatable.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object> get props => [];
}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteSuccess extends FavoriteState {
  final String message;

  const FavoriteSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class FavoriteFailure extends FavoriteState {
  final String error;

  const FavoriteFailure(this.error);

  @override
  List<Object> get props => [error];
}
