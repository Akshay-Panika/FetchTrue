import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/FiveXRepository.dart';
import 'FiveXEvent.dart';
import 'FiveXState.dart';


class FiveXBloc extends Bloc<FiveXEvent, FiveXState> {
  final FiveXRepository repository;

  FiveXBloc(this.repository) : super(FiveXInitial()) {
    on<FetchFiveX>((event, emit) async {
      emit(FiveXLoading());
      try {
        final data = await repository.fetchFiveXData();
        emit(FiveXLoaded(data));
      } catch (e) {
        emit(FiveXError(e.toString()));
      }
    });
  }
}
