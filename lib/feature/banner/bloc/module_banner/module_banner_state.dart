
import 'package:bizbooster2x/feature/home/model/banner_model.dart';

abstract class ModuleBannerState{}

class ModuleBannerInitial extends ModuleBannerState{}

class ModuleBannerLoading extends ModuleBannerState {}

class ModuleBannerLoaded extends ModuleBannerState {
  final List<ModuleBannerModel>  moduleBannerModel;
  ModuleBannerLoaded(this.moduleBannerModel);
}

class ModuleBannerError extends ModuleBannerState {
  final String errorMessage;
  ModuleBannerError(this.errorMessage);
}
