import 'package:dio/dio.dart';
import '../../../helper/api_helper.dart';
import '../../../helper/api_urls.dart';
import '../model/provider_model.dart';

class ProviderByIdService {
  final Dio _dio = ApiClient.dio;

  // ✅ Get provider by ID
  Future<ProviderModel> fetchProviderById(String providerId) async {
    try {
      final response = await _dio.get("${ApiUrls.provider}/$providerId");

      if (response.statusCode == 200) {
        final data = response.data;
        return ProviderModel.fromJson(data);
      } else {
        throw Exception('Invalid response status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      final errorMsg = e.response?.data ?? e.message;
      throw Exception('Dio error: $errorMsg');
    } catch (e) {
      throw Exception('Unexpected error in fetching provider: $e');
    }
  }
}
