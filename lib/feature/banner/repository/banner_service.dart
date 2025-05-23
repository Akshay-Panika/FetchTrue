
import 'package:bizbooster2x/helper/api_urls.dart';
import 'package:dio/dio.dart';

import '../model/banner_model.dart';

class BannerService {
   final Dio _dio = Dio();

   Future<List<ModuleBannerModel>> fetchBanner() async {
    try {
      final response = await _dio.get(ApiUrls.banner);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => ModuleBannerModel.fromJson(json)).toList();
      } else {
        throw Exception('Server returned error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch banners: $e');
    }
  }
}
