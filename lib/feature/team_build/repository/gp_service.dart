import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/gp_model.dart';

class GpService {
  Future<List<GpModel>> fetchMyLeads(String userId) async {
    final url = Uri.parse('https://biz-booster.vercel.app/api/users/my-team/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final leads = (jsonData['myLeads'] as List)
          .map((e) => GpModel.fromJson(e))
          .toList();
      return leads;
    } else {
      throw Exception('Failed to load leads');
    }
  }
}
