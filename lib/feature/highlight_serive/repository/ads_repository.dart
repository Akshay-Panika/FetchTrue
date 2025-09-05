import 'package:dio/dio.dart';
import 'package:fetchtrue/helper/api_client.dart';
import 'package:fetchtrue/helper/api_urls.dart';
import '../model/add_model.dart';

class AdsRepository {
  final Dio _dio = ApiClient.dio;

  Future<AdsModel> fetchAds() async {
    try {
      final response = await _dio.get(ApiUrls.ads);

      if (response.statusCode == 200) {
        return AdsModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load ads: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
