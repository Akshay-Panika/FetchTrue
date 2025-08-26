import 'package:equatable/equatable.dart';
import '../../model/customer_model.dart';
import '../../model/add_customer_model.dart';

abstract class CustomerState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CustomerInitial extends CustomerState {}

class CustomerLoading extends CustomerState {}

class CustomerLoaded extends CustomerState {
  final List<CustomerModel> customers;
  CustomerLoaded(this.customers);

  @override
  List<Object?> get props => [customers];
}

class CustomerError extends CustomerState {
  final String errorMessage;
  CustomerError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class CustomerCreated extends CustomerState {
  final AddCustomerModel customer;
  CustomerCreated(this.customer);

  @override
  List<Object?> get props => [customer];
}
