import 'package:dio/dio.dart';

class InfoService {
  final Dio _dio = Dio();

  Future<bool> updateUserInfo({
    required String userId,
    required String fullName,
    required String email,
  }) async {
    final String url = 'https://biz-booster.vercel.app/api/users/update-info/$userId';
    try {
      final response = await _dio.patch(
        url,
        data: {
          "fullName": fullName,
          "email": email,
        },
      );
      if (response.statusCode == 200 || response.data['success'] == true) {
        return true;
      }
      return false;
    } catch (e) {
      print('Update Error: $e');
      return false;
    }
  }
}
