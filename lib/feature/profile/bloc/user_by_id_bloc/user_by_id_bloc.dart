import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/user_by_id_repojetory.dart';
import 'user_by_id_event.dart';
import 'user_by_id_state.dart';

class UserByIdBloc extends Bloc<UserByIdEvent, UserByIdState> {
  final UserByIdRepository repository;

  UserByIdBloc(this.repository) : super(UserByIdInitial()) {
    on<GetUserById>((event, emit) async {
      emit(UserByIdLoading());
      try {
        final user = await repository.fetchUser(event.userId);
        emit(UserByIdLoaded(user));
      } catch (e) {
        emit(UserByIdError(e.toString()));
      }
    });
  }
}
