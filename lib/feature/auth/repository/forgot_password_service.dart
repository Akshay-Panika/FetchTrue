// lib/services/auth_service.dart

import 'package:dio/dio.dart';
import 'package:fetchtrue/helper/api_urls.dart';

import '../../../helper/api_helper.dart';

class ForgotPasswordService {
  Future<Response> forgotPasswordUser({
    required String mobileNumber,
    required String newPassword,
  }) async {
    try {
      final response = await ApiClient.dio.post(
       'https://biz-booster.vercel.app/api/auth/forgot-password',
        data: {
          "mobileNumber": mobileNumber,
          "newPassword": newPassword,
        },
      );
      return response;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? "Something went wrong";
    }
  }
}
