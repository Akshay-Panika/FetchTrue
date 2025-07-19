// blocs/wallet/wallet_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/wallet_service.dart';
import 'wallet_event.dart';
import 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc() : super(WalletInitial()) {
    on<FetchWalletByUser>((event, emit) async {
      emit(WalletLoading());
      try {
        final wallet = await WalletService.fetchWalletByUser(event.userId);
        emit(WalletLoaded(wallet));
      } catch (e) {
        emit(WalletError(e.toString()));
      }
    });
  }
}
