import 'package:dio/dio.dart';
import 'package:fetchtrue/helper/api_urls.dart';

import '../../../helper/api_helper.dart';
import '../model/sign_in_model.dart';

class UserSignInService {

  /// Login with email & password
  static Future<LoginResponse?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await ApiClient.dio.post(
        ApiUrls.signIn,
        data: {
          "email": email,
          "password": password,
        },
      );

      if (response.statusCode == 200) {
        return LoginResponse.fromJson(response.data);
      } else {
        print("Login failed: ${response.statusMessage}");
        return null;
      }
    } on DioException catch (e) {
      print("Login error: ${e.message}");
      return null;
    }
  }
}
