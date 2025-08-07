import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../profile/model/user_model.dart';

Future<UserModel?> fetchReferredUser(String userId) async {
  try {
    final response = await http.get(
      Uri.parse("https://biz-booster.vercel.app/api/users/$userId"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return UserModel.fromJson(data['data']);
      }
    }
    return null;
  } catch (e) {
    print("❌ Fetch Error: $e");
    return null;
  }
}
