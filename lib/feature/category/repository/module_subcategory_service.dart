

import 'package:dio/dio.dart';

import '../../../helper/api_urls.dart';
import '../model/module_subcategory_model.dart';

class SubCategoryService {
  final Dio _dio = Dio();

  Future<List<ModuleSubCategoryModel>> fetchSubCategory() async {
    try {
      final response = await _dio.get(ApiUrls.modulesSubcategory);

      if (response.statusCode == 200 && response.data['success'] == true) {
        List data = response.data['data'];
        return data.map((json) => ModuleSubCategoryModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load sub-categories');
      }
    } catch (e) {
      throw Exception('API Error: $e');
    }
  }
}