import 'package:dio/dio.dart';

import '../model/user_model.dart';

class AllUserRepository {
  final Dio _dio = Dio();

  Future<List<UserModel>> fetchAllUsers() async {
    try {
      final response = await _dio.get('https://biz-booster.vercel.app/api/users');
      final List users = response.data['users'];
      return users.map((json) => UserModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch users: $e');
    }
  }
}
