import 'package:bizbooster2x/feature/provider/model/provider_model.dart';
import 'package:bizbooster2x/feature/service/model/service_model.dart';
import 'package:bizbooster2x/helper/api_urls.dart';
import 'package:dio/dio.dart';
import '../../../helper/api_helper.dart';

class ProviderService {
  final Dio _dio = ApiClient.dio;


  Future<List<ProviderModel>> fetchProvider() async {
    try {
      final response = await _dio.get(ApiUrls.provider);

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => ProviderModel.fromJson(json)).toList();
      } else {
        throw Exception('Invalid response format or status: ${response.statusCode}');
      }
    }
    on DioException catch (e) {
      final errorMsg = e.response?.data ?? e.message;
      throw Exception('Dio error: $errorMsg');
    }
    catch (e) {
      throw Exception('Unexpected error in fetching provider: $e');
    }
  }
}