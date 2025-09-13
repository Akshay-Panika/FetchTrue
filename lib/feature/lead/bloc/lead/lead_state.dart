import 'package:equatable/equatable.dart';
import '../../model/lead_model.dart';

abstract class LeadState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LeadInitial extends LeadState {}

class LeadLoading extends LeadState {}

class LeadLoaded extends LeadState {
  final List<LeadModel> leadModel;
  LeadLoaded(this.leadModel);

  @override
  List<Object?> get props => [leadModel];
}

class LeadError extends LeadState {
  final String message;
  LeadError(this.message);

  @override
  List<Object?> get props => [message];
}
