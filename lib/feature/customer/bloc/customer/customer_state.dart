

import '../../model/customer_model.dart';

abstract class CustomerState{}

class CustomerInitial extends CustomerState{}

class CustomerLoading extends CustomerState {}

class CustomerLoaded extends CustomerState {
  final List<CustomerModel>  customerModel;
  CustomerLoaded(this.customerModel);
}

class CustomerError extends CustomerState {
  final String errorMessage;
   CustomerError(this.errorMessage);
}
