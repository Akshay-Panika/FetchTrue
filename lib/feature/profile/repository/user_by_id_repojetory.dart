import 'package:dio/dio.dart';
import '../model/user_model.dart';

class UserByIdRepository {
  final Dio _dio = Dio();

  Future<UserModel> fetchUser(String userId) async {
    try {
      final response = await _dio.get('https://biz-booster.vercel.app/api/users/$userId');

      if (response.data['success'] == true) {
        return UserModel.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to load user');
      }
    } catch (e) {
      throw Exception('Error fetching user: $e');
    }
  }
}
