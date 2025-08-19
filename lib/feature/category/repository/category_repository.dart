
import 'package:dio/dio.dart';
import 'package:fetchtrue/feature/category/model/category_model.dart';
import 'package:fetchtrue/helper/api_urls.dart';
import '../../banner/model/banner_model.dart';

class CategoryRepository {
  final Dio _dio = Dio();

  Future<List<CategoryModel>> getCategory() async {
    try {
      final response = await _dio.get(ApiUrls.modulesCategory);

      if (response.statusCode == 200 && response.data["success"] == true && response.data["data"] != null) {
        return (response.data["data"] as List).map((e) => CategoryModel.fromJson(e)).toList();
      } else {
        throw Exception("Failed to fetch category");
      }
    }
    on DioException catch (dioError) {
      throw Exception("Dio error: ${dioError.message}");
    }
    catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}
