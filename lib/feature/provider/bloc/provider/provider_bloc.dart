import 'package:bizbooster2x/feature/provider/repository/provider_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'provider_event.dart';
import 'provider_state.dart';

class ProviderBloc extends Bloc<ProviderEvent, ProviderState> {
  final ProviderService providerService;

  ProviderBloc(this.providerService) : super(ProviderInitial()) {
    on<GetProvider>((event, emit) async {
      emit(ProviderLoading());
      try {
        final provider = await providerService.fetchProvider();
        emit(ProviderLoaded(provider));
      } catch (e) {
        emit(ProviderError(e.toString()));
      }
    });
  }
}
