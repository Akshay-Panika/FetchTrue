import 'package:dio/dio.dart';
import '../../../helper/api_helper.dart';
import '../../../helper/api_urls.dart';
import '../model/sign_in_model.dart';

class SignInService {
  /// Login User
  Future<Map<String, dynamic>> loginUser(SignInModel model) async {
    try {
      final response = await ApiClient.dio.post(
        ApiUrls.signIn,
        data: model.toJson(),
      );

      print('API Raw Response: ${response.data}');

      /// If status is OK and token is received, consider login successful
      if (response.statusCode == 200 && response.data['token'] != null) {
        return {
          'success': true,
          'data': response.data, // full data including token & user
          'message': response.data['message'] ?? 'Login successful',
        };
      }

      /// Unexpected response structure
      return {
        'success': false,
        'message': response.data['message'] ?? 'Login failed',
      };
    } on DioException catch (e) {
      String errorMessage = 'Something went wrong';

      if (e.response != null && e.response?.data != null) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        errorMessage = e.message ?? errorMessage;
      }

      return {
        'success': false,
        'message': errorMessage,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Unexpected error: $e',
      };
    }
  }
}
