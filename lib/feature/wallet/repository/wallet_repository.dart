import 'package:dio/dio.dart';
import '../model/wallet_model.dart';

class WalletRepository {
  final Dio _dio;

  WalletRepository([Dio? dio]) : _dio = dio ?? Dio();

  Future<WalletModel?> fetchWalletByUserId(String userId) async {
    final url = 'https://biz-booster.vercel.app/api/wallet/fetch-by-user/$userId';

    try {
      final response = await _dio.get(url);
      if (response.statusCode == 200) {
        final data = response.data;
        return WalletModel.fromJson(data);
      } else {
        print('Failed to load wallet data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching wallet data: $e');
    }
    return null;
  }
}