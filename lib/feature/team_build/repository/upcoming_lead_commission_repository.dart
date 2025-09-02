import 'package:dio/dio.dart';
import '../../../helper/api_urls.dart';
import '../model/upcoming_lead_commission_model.dart';

class UpcomingLeadCommissionRepository {
  final Dio _dio = Dio();

  Future<UpcomingLeadCommissionModel> fetchCommission(String checkoutId) async {
    try {
      final response = await _dio.get(
        "${ApiUrls.upcomingLeadCommission}/$checkoutId",
      );

      if (response.statusCode == 200) {
        return UpcomingLeadCommissionModel.fromJson(response.data);
      } else {
        throw Exception("Failed to load commission data");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
