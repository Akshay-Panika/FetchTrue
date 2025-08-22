// provider_review_repository.dart
import 'package:dio/dio.dart';
import 'package:fetchtrue/helper/api_urls.dart';
import '../model/provider_review_model.dart';

class ProviderReviewRepository {
  final Dio _dio = Dio();

  Future<ProviderReviewModel?> getProviderReviews(String providerId) async {
    try {
      final response = await _dio.get("${ApiUrls.providerReview}/$providerId");

      if (response.statusCode == 200) {
        return ProviderReviewModel.fromJson(response.data);
      } else {
        throw Exception("Failed to load provider reviews");
      }
    } on DioError catch (e) {
      print("Dio error: ${e.message}");
      return null;
    } catch (e) {
      print("Unknown error: $e");
      return null;
    }
  }
}
