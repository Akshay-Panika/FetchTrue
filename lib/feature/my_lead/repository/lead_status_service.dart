import 'package:fetchtrue/feature/my_lead/model/lead_status_model.dart';
import '../../../helper/api_helper.dart';
import '../../../helper/api_urls.dart';

class LeadStatusService {
  static Future<List<LeadStatusModel>> fetchLeadStatus() async {
    try {
      final response = await ApiClient.dio.get(ApiUrls.leadStatus);
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => LeadStatusModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load leads');
      }
    } catch (e) {
      print("❌ Error fetching leads: $e");
      rethrow;
    }
  }
}
