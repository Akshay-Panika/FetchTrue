import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/all_user_repository.dart';
import 'all_user_event.dart';
import 'all_user_state.dart';


class AllUserBloc extends Bloc<AllUserEvent, AllUserState> {
  final AllUserRepository userRepository;

  AllUserBloc(this.userRepository) : super(AllUserInitial()) {
    on<AllFetchUsers>((event, emit) async {
      emit(AllUserLoading());
      try {
        final users = await userRepository.fetchAllUsers();
        emit(AllUserLoaded(users));
      } catch (e) {
        emit(AllUserError(e.toString()));
      }
    });
  }
}
