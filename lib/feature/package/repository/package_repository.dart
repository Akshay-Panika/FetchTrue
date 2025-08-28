import 'package:dio/dio.dart';
import 'package:fetchtrue/helper/api_urls.dart';
import '../model/package_model.dart';

class PackageRepository {
  static final Dio _dio = Dio();
  static Future<List<PackageModel>> getPackages() async {
    final response = await _dio.get(ApiUrls.packages);

    if (response.statusCode == 200) {
      final data = response.data;

      if (data is List) {
        return data.map((item) => PackageModel.fromJson(item as Map<String, dynamic>)).toList();
      } else if (data is Map) {
        return [PackageModel.fromJson(data as Map<String, dynamic>)];
      }
    }
    throw Exception("Failed to load packages");
  }
}
