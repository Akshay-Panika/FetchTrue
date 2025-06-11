import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/customer_service.dart';
import 'customer_event.dart';
import 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final CustomerService customerService;

   CustomerBloc(this.customerService) : super(CustomerInitial()) {
    on<GetCustomer>((event, emit) async {
      emit(CustomerLoading());
      try {
        final customer = await customerService.fetchCustomer();
        emit(CustomerLoaded(customer));
      } catch (e) {
        emit(CustomerError(e.toString()));
      }
    });
  }
}
