import '../../model/user_model.dart';

abstract class UserByIdState {}

class UserByIdInitial extends UserByIdState {}

class UserByIdLoading extends UserByIdState {}

class UserByIdLoaded extends UserByIdState {
  final UserModel user;
  UserByIdLoaded(this.user);
}

class UserByIdError extends UserByIdState {
  final String message;
  UserByIdError(this.message);
}
