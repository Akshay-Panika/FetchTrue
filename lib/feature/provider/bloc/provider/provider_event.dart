import 'package:equatable/equatable.dart';

abstract class ProviderEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetProviders extends ProviderEvent {}

class GetProviderById extends ProviderEvent {
  final String id;
  GetProviderById(this.id);

  @override
  List<Object?> get props => [id];
}

class FilterProvidersEvent extends ProviderEvent {
  final String filter;
  FilterProvidersEvent(this.filter);

  @override
  List<Object?> get props => [filter];
}

