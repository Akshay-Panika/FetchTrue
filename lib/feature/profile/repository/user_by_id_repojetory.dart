import 'package:dio/dio.dart';
import 'package:fetchtrue/helper/api_urls.dart';
import '../model/user_model.dart';

class UserByIdRepository {
  final Dio _dio = Dio();

  Future<UserModel> getUserById(String userId) async {
    try {
      final response = await _dio.get('${ApiUrls.user}/$userId');

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
