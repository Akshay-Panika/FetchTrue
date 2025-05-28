
import 'package:dio/dio.dart';
import '../../../helper/api_helper.dart';
import '../../../helper/api_urls.dart';
import '../model/module_category_model.dart';


class ModuleCategoryService {
  final Dio _dio = ApiClient.dio;


  Future<List<ModuleCategoryModel>> fetchModuleCategory() async {
    try {
      final response = await _dio.get(ApiUrls.modulesCategory);

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => ModuleCategoryModel.fromJson(json)).toList();
      } else {
        throw Exception('Invalid response format or status: ${response.statusCode}');
      }
    }
    on DioException catch (e) {
      final errorMsg = e.response?.data ?? e.message;
      throw Exception('Dio error: $errorMsg');
    }
    catch (e) {
      throw Exception('Unexpected error in fetching category: $e');
    }
  }
}