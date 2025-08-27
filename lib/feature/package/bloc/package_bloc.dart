import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fetchtrue/feature/package/bloc/package_event.dart';
import 'package:fetchtrue/feature/package/bloc/package_state.dart';
import '../repository/package_repository.dart';

class PackageBloc extends Bloc<PackageEvent, PackageState> {
  PackageBloc() : super(PackageInitial()) {
    on<FetchPackages>((event, emit) async {
      emit(PackageLoading());
      try {
        final packages = await PackageRepository.getPackages(); // returns List<PackageModel>
        emit(PackageLoaded(packages));
      } catch (e) {
        emit(PackageError(e.toString()));
      }
    });
  }
}
