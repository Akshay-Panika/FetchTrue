
import 'package:dio/dio.dart';
import '../../../helper/api_urls.dart';
import '../model/module_category_model.dart';

class  ModuleCategoryService{
  final Dio _dio = Dio();
  Future<List<ModuleCategoryModel>> fetchModuleCategory() async {
    try {
      final response = await _dio.get(ApiUrls.modulesCategory);

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> data = response.data['data'];

        return data.map((json) => ModuleCategoryModel.fromJson(json)).toList();
      } else {
        throw Exception('Server returned error: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('API Error: $e');
    }
  }
}
