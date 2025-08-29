import 'package:dio/dio.dart';
import 'package:fetchtrue/helper/api_urls.dart';

class UserAdditionalDetailsService {
  final Dio _dio;
  UserAdditionalDetailsService({Dio? dio}) : _dio = dio ?? Dio();

  Future<void> updateAdditionalDetails({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _dio.patch(
        '${ApiUrls.user}/additional-details/$userId',
        data: data,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode != 200) {
        throw Exception(
            'PATCH failed: ${response.statusCode} - ${response.statusMessage}');
      }
    } on DioException catch (dioError) {
      if (dioError.response != null) {
        throw Exception(
            'API Error: ${dioError.response?.statusCode} - ${dioError.response?.data}');
      } else {
        throw Exception('Network Error: ${dioError.message}');
      }
    } catch (e) {
      throw Exception('Unexpected Error: $e');
    }
  }
}
