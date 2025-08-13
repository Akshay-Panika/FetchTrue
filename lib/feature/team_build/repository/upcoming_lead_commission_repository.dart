import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/upcoming_lead_commission_model.dart';

class UpcomingLeadCommissionRepository {
  Future<UpcomingLeadCommissionModel> fetchCommission(String checkoutId) async {
    final url = Uri.parse(
      "https://biz-booster.vercel.app/api/upcoming-lead-commission/find-by-checkoutId/$checkoutId",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return UpcomingLeadCommissionModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load commission data");
    }
  }
}
