import 'package:dio/dio.dart';

import '../../../helper/api_urls.dart';
import '../model/module_model.dart';

class ModuleService {
  final Dio _dio = Dio();

  // final Dio _dio = Dio(BaseOptions(
  //   baseUrl: ApiUrls.baseUrl,
  //   connectTimeout: const Duration(seconds: 10),
  //   receiveTimeout: const Duration(seconds: 10),
  //   headers: {'Content-Type': 'application/json'},
  // ));

  Future<List<ModuleModel>> fetchModules() async {
    try {
      final response = await _dio.get(ApiUrls.modules);

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => ModuleModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load modules: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('API Error: $e');
    }
  }
}