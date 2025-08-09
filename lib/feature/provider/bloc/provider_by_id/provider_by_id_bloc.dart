import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/provider_by_id_service.dart';
import 'provider_by_id_event.dart';
import 'provider_by_id_state.dart';

class ProviderByIdBloc extends Bloc<ProviderByIdEvent, ProviderByIdState> {
  final ProviderByIdService providerService;

  ProviderByIdBloc(this.providerService) : super(ProviderInitial()) {
    on<GetProviderByIdEvent>(_onGetProviderById);
  }

  Future<void> _onGetProviderById(
      GetProviderByIdEvent event,
      Emitter<ProviderByIdState> emit,
      ) async {
    emit(ProviderLoading());
    try {
      final provider = await providerService.fetchProviderById(event.providerId);
      emit(ProviderLoaded(provider));
    } catch (e) {
      emit(ProviderError(e.toString()));
    }
  }
}