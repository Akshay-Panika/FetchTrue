import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/user_service.dart';
import 'user_event.dart';
import 'user_state.dart';


class UserBloc extends Bloc<UserEvent, UserState> {
  final UserService userService;

  UserBloc(this.userService) : super(UserInitial()) {
    on<FetchUserById>(_onFetchUserById);
    on<UserReset>((event, emit) {
      emit(UserInitial()); // ✅ This resets the user state
    });
  }

  Future<void> _onFetchUserById(FetchUserById event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final user = await userService.fetchUserById(event.userId);
      if (user != null) {
        emit(UserLoaded(user));
      } else {
        emit(UserError("User not found or response failed"));
      }
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
