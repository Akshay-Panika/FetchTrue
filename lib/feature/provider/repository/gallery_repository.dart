import 'package:dio/dio.dart';
import '../model/gallery_model.dart';

class GalleryRepository {
  final Dio _dio = Dio();
  final String baseUrl = "https://biz-booster.vercel.app/api/provider";

  Future<GalleryModel> fetchGallery(String providerId) async {
    try {
      final response = await _dio.get("$baseUrl/$providerId/gallery");

      if (response.statusCode == 200) {
        return GalleryModel.fromJson(response.data);
      } else {
        throw Exception("Failed to load gallery");
      }
    } catch (e) {
      throw Exception("Error fetching gallery: $e");
    }
  }
}
