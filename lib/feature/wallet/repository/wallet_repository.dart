import 'package:dio/dio.dart';
import '../../../helper/api_urls.dart';
import '../model/wallet_model.dart';

class WalletRepository {
  final Dio _dio;

  WalletRepository([Dio? dio]) : _dio = dio ?? Dio();

  Future<WalletModel?> fetchWalletByUserId(String userId) async {
    final url = '${ApiUrls.wallet}/$userId';

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