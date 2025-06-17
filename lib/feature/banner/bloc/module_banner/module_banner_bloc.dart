import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/banner_service.dart';
import 'module_banner_event.dart';
import 'module_banner_state.dart';

class ModuleBannerBloc extends Bloc<ModuleBannerEvent, ModuleBannerState> {
  final BannerService bannerService;

  ModuleBannerBloc(this.bannerService) : super(ModuleBannerInitial()) {
    on<GetModuleBanner>((event, emit) async {
      emit(ModuleBannerLoading());
      try {
        final moduleBanner = await bannerService.fetchBanner();
        emit(ModuleBannerLoaded(moduleBanner));
      } catch (e) {
        emit(ModuleBannerError(e.toString()));
      }
    });
  }
}