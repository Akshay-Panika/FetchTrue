import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/wallet_model.dart';

class WalletService {
  static Future<WalletModel> fetchWalletByUser(String userId) async {
    final url = Uri.parse('https://biz-booster.vercel.app/api/wallet/fetch-by-user/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['success'] == true) {
        return WalletModel.fromJson(jsonData['data']);
      } else {
        throw Exception('Failed to load wallet');
      }
    } else {
      throw Exception('API Error');
    }
  }
}
