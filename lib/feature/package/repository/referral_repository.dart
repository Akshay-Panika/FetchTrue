import 'package:dio/dio.dart';

import '../model/referral_user_model.dart';

class ReferralRepository {
  final Dio _dio = Dio();

  Future<List<ReferralUser>> fetchReferrals(String userId) async {
    try {
      final response = await _dio.get(
        "https://api.fetchtrue.com/api/users/$userId/referrals",
      );

      if (response.statusCode == 200 && response.data["success"] == true) {
        List users = response.data["users"];
        return users.map((e) => ReferralUser.fromJson(e)).toList();
      } else {
        throw Exception("Failed to load referrals");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
