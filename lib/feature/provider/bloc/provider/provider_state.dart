import 'package:equatable/equatable.dart';

import '../../model/provider_model.dart';

abstract class ProviderState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProviderInitial extends ProviderState {}

class ProviderLoading extends ProviderState {}

class ProvidersLoaded extends ProviderState {
  final List<ProviderModel> providers;
  ProvidersLoaded(this.providers);

  @override
  List<Object?> get props => [providers];
}

class ProviderLoaded extends ProviderState {
  final ProviderModel provider;
  ProviderLoaded(this.provider);

  @override
  List<Object?> get props => [provider];
}

class ProviderError extends ProviderState {
  final String message;
  ProviderError(this.message);

  @override
  List<Object?> get props => [message];
}
