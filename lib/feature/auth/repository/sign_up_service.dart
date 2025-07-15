// lib/services/auth_service.dart

import 'package:dio/dio.dart';
import 'package:fetchtrue/helper/api_urls.dart';

import '../../../helper/api_helper.dart';

class SignUpService {
  Future<Response> registerUser({
    required String fullName,
    required String email,
    required String mobileNumber,
    required String password,
    required String referredBy,
    required bool isAgree,
  }) async {
    try {
      final response = await ApiClient.dio.post(
        ApiUrls.signUp,
        data: {
          "fullName": fullName,
          "email": email,
          "mobileNumber": mobileNumber,
          "password": password,
          "referredBy": referredBy,
          "isAgree": isAgree,
        },
      );
      return response;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? "Something went wrong";
    }
  }
}
