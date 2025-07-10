import 'package:dio/dio.dart';
import '../model/user_model.dart';

class UserService {
  final Dio _dio = Dio();
  final String baseUrl = 'https://biz-booster.vercel.app/api/users';

  Future<UserModel?> fetchUserById(String userId) async {
    try {
      final response = await _dio.get('$baseUrl/$userId');
      if (response.statusCode == 200 && response.data['success'] == true) {
        return UserModel.fromJson(response.data['data']);
      }
    } catch (e) {
      print('Fetch Error: $e');
    }
    return null;
  }
}
