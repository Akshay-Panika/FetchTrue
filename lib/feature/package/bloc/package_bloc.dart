import 'package:fetchtrue/feature/package/bloc/package_event.dart';
import 'package:fetchtrue/feature/package/bloc/package_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/package_service.dart';

class PackageBloc extends Bloc<PackageEvent, PackageState> {
  PackageBloc() : super(PackageInitial()) {
    on<FetchPackages>((event, emit) async {
      emit(PackageLoading());
      try {
        final packages = await PackageService.fetchPackages();
        emit(PackageLoaded(packages));
      } catch (e) {
        emit(PackageError(e.toString()));
      }
    });
  }
}
