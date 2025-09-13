import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/provider_repository.dart';
import 'provider_event.dart';
import 'provider_state.dart';

class ProviderBloc extends Bloc<ProviderEvent, ProviderState> {
  final ProviderRepository repository;
  ProviderBloc(this.repository) : super(ProviderInitial()) {
    on<GetProviders>((event, emit) async {
      emit(ProviderLoading());
      try {
        final provider = await repository.getProvider();
        emit(ProvidersLoaded(provider));
      } catch (e) {
        emit(ProviderError(e.toString()));
      }
    });

    on<GetProviderById>((event, emit) async {
      emit(ProviderLoading());
      try {
        final providerById = await repository.getProviderById(event.id);
        emit(ProviderLoaded(providerById!));
      } catch (e) {
        emit(ProviderError(e.toString()));
      }
    });
  }
}
