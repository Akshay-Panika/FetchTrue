
import 'package:bizbooster2x/helper/api_urls.dart';
import 'package:dio/dio.dart';

import '../../../helper/api_helper.dart';
import '../model/banner_model.dart';

class BannerService {
  final Dio _dio = ApiClient.dio;

  Future<List<ModuleBannerModel>> fetchBanner() async {
    try {
      final response = await _dio.get(ApiUrls.banner);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => ModuleBannerModel.fromJson(json)).toList();
      }
      else {
        throw Exception('Invalid response format or status: ${response.statusCode}');
      }
    }
    on DioException catch (e) {
      final errorMsg = e.response?.data ?? e.message;
      throw Exception('Dio error: $errorMsg');
    }
    catch (e) {
      throw Exception('Unexpected error in fetching banners: $e');
    }
  }
}
