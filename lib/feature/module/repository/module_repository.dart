import 'package:dio/dio.dart';
import 'package:fetchtrue/helper/api_urls.dart';
import '../../banner/model/banner_model.dart';

class ModuleRepository {
  final Dio _dio = Dio();

  Future<List<ModuleModel>> fetchModules() async {
    try {
      final response =
      await _dio.get(ApiUrls.modules);

      if (response.statusCode == 200 && response.data["success"] == true && response.data["data"] != null) {
        return (response.data["data"] as List).map((e) => ModuleModel.fromJson(e)).toList();
      } else {
        throw Exception("Failed to fetch modules");
      }
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}
