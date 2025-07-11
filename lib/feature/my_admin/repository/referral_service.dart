import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/referral_user_model.dart';

class ReferralService {
  Future<ReferralUserModel?> getUserByReferralCode(String code) async {
    final url = Uri.parse(
        'https://biz-booster.vercel.app/api/users/referredby?referralCode=$code');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return ReferralUserModel.fromJson(jsonData['data']);
      } else {
        print('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Fetch referral user error: $e');
      return null;
    }
  }
}
