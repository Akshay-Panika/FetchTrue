import 'package:dio/dio.dart';
import 'package:fetchtrue/helper/api_urls.dart';
import '../../../helper/api_client.dart';
import '../model/sign_in_model.dart';

class SignInService {
  static Future<LoginResponse?> signIn({
    required String mobileNumber,
    required String email,
    required String password,
  }) async {
    try {
      final response = await ApiClient.dio.post(
        ApiUrls.signIn,
        data: {
          'mobileNumber': mobileNumber,
          'email': email,
          'password': password,
        },
      );
      return LoginResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.data != null) {
        throw e.response?.data['error'] ?? "Login failed";
      } else {
        throw "Something went wrong. Please try again.";
      }
    }
  }
}
