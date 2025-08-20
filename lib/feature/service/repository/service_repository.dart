import 'package:dio/dio.dart';
import 'package:fetchtrue/helper/api_urls.dart';
import '../model/service_model.dart';

class ServiceRepository {
  final Dio _dio = Dio();
  Future<List<ServiceModel>> fetchServices() async {
    try {
      final response = await _dio.get(ApiUrls.modulesService);

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map<String, dynamic> && data['success'] == true) {
          final List<dynamic> list = data['data'] ?? [];
          return list.map((json) => ServiceModel.fromJson(json)).toList();
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to fetch services: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching services: $e');
    }
  }
}
