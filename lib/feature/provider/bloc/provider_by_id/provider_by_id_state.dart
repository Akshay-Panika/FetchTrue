import '../../model/provider_model.dart';

abstract class ProviderByIdState {}

class ProviderInitial extends ProviderByIdState {}

class ProviderLoading extends ProviderByIdState {}

class ProviderLoaded extends ProviderByIdState {
  final ProviderModel provider;

  ProviderLoaded(this.provider);
}

class ProviderError extends ProviderByIdState {
  final String message;

  ProviderError(this.message);
}
