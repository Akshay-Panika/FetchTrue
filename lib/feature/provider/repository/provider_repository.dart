import 'package:dio/dio.dart';
import 'package:fetchtrue/helper/api_urls.dart';

import '../model/provider_model.dart';

class ProviderRepository {
  final Dio _dio = Dio();

  Future<List<ProviderModel>> getProviders() async {
    try {
      final response = await _dio.get(ApiUrls.provider);

      if (response.statusCode == 200) {
        final List data = response.data;
        return data.map((json) => ProviderModel.fromJson(json)).toList();
      } else {
        throw Exception("Failed to fetch providers");
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }


  Future<ProviderModel> getProviderById(String id) async {
    try {
      final response = await _dio.get('${ApiUrls.provider}/$id');

      if (response.statusCode == 200) {
        return ProviderModel.fromJson(response.data);
      } else {
        throw Exception("Failed to fetch providers");
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  String _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      return "Connection timeout. Please try again.";
    } else if (e.type == DioExceptionType.receiveTimeout) {
      return "Server is not responding.";
    } else if (e.response != null) {
      return e.response?.data["message"] ?? "Something went wrong!";
    } else {
      return "Unexpected error occurred.";
    }
  }
}
