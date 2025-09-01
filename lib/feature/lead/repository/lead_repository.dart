import 'package:dio/dio.dart';
import 'package:fetchtrue/helper/api_urls.dart';
import '../model/lead_model.dart';

class LeadRepository {
  final Dio _dio = Dio();

  Future<LeadModel?> getBookingsByUser(String userId) async {
    try {
      final response = await _dio.get("${ApiUrls.leads}/$userId");

      if (response.statusCode == 200) {
        return LeadModel.fromJson(response.data);
      } else {
        print("❌ Error: ${response.statusCode}");
        return null;
      }
    } on DioException catch (e) {
      print("❌ Dio Error: ${e.message}");
      return null;
    }
  }
}
