// subcategory_repository.dart
import 'package:dio/dio.dart';
import '../model/subcategory_model.dart';

class SubcategoryRepository {
  final Dio _dio = Dio();

  Future<List<SubcategoryModel>> getSubcategories() async {
    try {
      final response = await _dio.get("https://biz-booster.vercel.app/api/subcategory");

      if (response.statusCode == 200 && response.data['success'] == true) {
        List data = response.data['data'];
        return data.map((e) => SubcategoryModel.fromJson(e)).toList();
      } else {
        throw Exception("Failed to load subcategories");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
