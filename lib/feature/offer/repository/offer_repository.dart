import 'package:dio/dio.dart';
import 'package:fetchtrue/helper/api_urls.dart';
import '../model/offer_model.dart';

class OfferRepository {
  static final Dio _dio = Dio();

  static Future<List<OfferModel>> fetchOffers() async {
    try {
      final response = await _dio.get("${ApiUrls.baseUrl}/offer");

      if (response.statusCode == 200) {
        final data = response.data;
        final List offers = data["data"];
        return offers.map((e) => OfferModel.fromJson(e)).toList();
      } else {
        throw Exception("Failed to load offers");
      }
    } on DioException catch (e) {
      throw Exception("Dio error: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}
