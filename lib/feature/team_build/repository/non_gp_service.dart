import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/non_gp_model.dart';

class NonGpService {
  Future<List<NonGpModel>> fetchMyLeads(String userId) async {
    final url = Uri.parse('https://biz-booster.vercel.app/api/users/my-team/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      print('API Response: $jsonBody'); // 🧪 Debug

      if (jsonBody['success'] == true && jsonBody['myLeads'] != null) {
        final leads = jsonBody['myLeads'] as List;
        return leads.map((e) => NonGpModel.fromJson(e)).toList();
      }
    } else {
      print("API Error: ${response.statusCode}");
    }

    return [];
  }
}
