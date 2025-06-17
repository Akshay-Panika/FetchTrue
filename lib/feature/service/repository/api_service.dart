import 'package:dio/dio.dart';
import '../../../helper/api_helper.dart';
import '../../../helper/api_urls.dart';
import '../model/service_model.dart';

class ApiService {
  final Dio _dio = ApiClient.dio;


  Future<List<ServiceModel>> fetchServices() async {
    try {
      final response = await _dio.get(ApiUrls.modulesService);

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => ServiceModel.fromJson(json)).toList();
      } else {
        throw Exception('Invalid response format or status: ${response.statusCode}');
      }
    }
    on DioException catch (e) {
      final errorMsg = e.response?.data ?? e.message;
      throw Exception('Dio error: $errorMsg');
    }
    catch (e) {
      throw Exception('Unexpected error in fetching service: $e');
    }
  }
}