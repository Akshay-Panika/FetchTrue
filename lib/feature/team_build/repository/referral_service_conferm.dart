// referral_service_conferm.dart

import 'package:http/http.dart' as http;
import 'dart:convert';

class ReferralServiceConfirm {
  final String _baseUrl = 'https://biz-booster.vercel.app/api/users/referredby';

  Future<bool> setReferralForUser({required String userId, required String referralCode}) async {
    try {
      final response = await http.patch(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "userId": userId,
          "referralCode": referralCode,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        return true;
      } else {
        print("❌ API Error: ${data['message']}");
        return false;
      }
    } catch (e) {
      print("❌ Exception: $e");
      return false;
    }
  }
}
