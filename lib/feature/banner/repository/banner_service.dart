
import 'package:dio/dio.dart';

import '../../home/model/banner_model.dart';

class BannerService {
   final Dio _dio = Dio();

   Future<List<ModuleBannerModel>> fetchBanners() async {
    try {
      final response = await _dio.get('https://biz-booster.vercel.app/api/banner');

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
