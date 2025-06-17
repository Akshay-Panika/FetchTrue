
import '../../model/provider_model.dart';

abstract class ProviderState{}

class ProviderInitial extends ProviderState{}

class ProviderLoading extends ProviderState {}

class ProviderLoaded extends ProviderState {
  final List<ProviderModel>  providerModel;
  ProviderLoaded(this.providerModel);
}

class ProviderError extends ProviderState {
  final String errorMessage;
  ProviderError(this.errorMessage);
}
