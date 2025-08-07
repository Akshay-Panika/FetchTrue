import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/referred_user_model.dart';

class ReferralService {
  static Future<ReferredUser?> verifyReferralCode(String referralCode) async {
    final uri = Uri.parse(
        'https://biz-booster.vercel.app/api/users/referredby?referralCode=$referralCode');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return ReferredUser.fromJson(data['data']);
      }
    }

    return null;
  }
}
