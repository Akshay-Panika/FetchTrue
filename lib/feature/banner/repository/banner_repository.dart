import 'package:dio/dio.dart';
import 'package:fetchtrue/helper/api_helper.dart';
import 'package:fetchtrue/helper/api_urls.dart';
import '../model/banners_model.dart';

class BannerRepository {
  final Dio _dio = ApiClient.dio;

  Future<List<BannerModel>> fetchBanners() async {
    try {
      final response = await _dio.get(ApiUrls.banner);

      if (response.statusCode == 200 && response.data != null) {
        return (response.data as List)
            .map((e) => BannerModel.fromJson(e))
            .toList();
      } else {
        throw Exception("Failed to fetch banners");
      }
    } on DioException catch (dioError) {
      throw Exception("Dio error: ${dioError.message}");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}
