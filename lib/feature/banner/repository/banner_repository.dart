import 'package:dio/dio.dart';
import 'package:fetchtrue/helper/api_urls.dart';
import '../model/banners_model.dart';

class BannerRepository {
  final Dio _dio = Dio();

  Future<List<BannerModel>> fetchBanners({String? page}) async {
    final response = await _dio.get(ApiUrls.banner);
    if (response.statusCode == 200) {
      final data = response.data as List;
      final banners = data.map((e) => BannerModel.fromJson(e)).toList();
      if (page != null) {
        return banners.where((b) => b.page == page).toList();
      }
      return banners;
    } else {
      throw Exception("Failed to load banners");
    }
  }
}
