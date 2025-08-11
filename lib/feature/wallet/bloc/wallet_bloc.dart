import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../model/wallet_model.dart';
import 'wallet_event.dart';
import 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final Dio dio;

  WalletBloc({Dio? dioClient})
      : dio = dioClient ?? Dio(),
        super(WalletInitial()) {
    on<FetchWallet>((event, emit) async {
      emit(WalletLoading());
      final url = 'https://biz-booster.vercel.app/api/wallet/fetch-by-user/${event.userId}';

      try {
        final response = await dio.get(url);
        if (response.statusCode == 200) {
          final wallet = WalletModel.fromJson(response.data);
          emit(WalletLoaded(wallet));
        } else {
          emit(WalletError('Failed to load wallet data: ${response.statusCode}'));
        }
      } catch (e) {
        emit(WalletError('Error: $e'));
      }
    });
  }
}