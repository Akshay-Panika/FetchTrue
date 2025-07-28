// lib/feature/user/service/user_service.dart

import 'package:dio/dio.dart';

class UserAdditionalDetailsService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://biz-booster.vercel.app/api/users';

  Future<void> updateAdditionalDetails({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _dio.patch(
        '$_baseUrl/additional-details/$userId',
        data: data,
      );

      if (response.statusCode == 200) {
        print('✅ PATCH Success: ${response.data}');
      } else {
        throw Exception('⚠️ PATCH failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('❌ API Error: $e');
    }
  }
}
