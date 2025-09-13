import 'package:dio/dio.dart';
import 'package:fetchtrue/feature/advisers/model/advisor_model.dart';
import 'package:fetchtrue/helper/api_client.dart';
import 'package:fetchtrue/helper/api_urls.dart';

class AdvisorRepository {
  final Dio _dio = OldApiClient.dio;

  Future<List<AdvisorModel>> fetchAdvisors() async {
    try {
      final response = await _dio.get(ApiUrls.advisor);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data['data'] as List<dynamic>;
        return data.map((json) => AdvisorModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load advisors: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
