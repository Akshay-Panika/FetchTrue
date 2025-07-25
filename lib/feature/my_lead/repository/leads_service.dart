import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/lead_model.dart';

class LeadRepository {
  Future<List<LeadModel>> fetchLeads(String userId) async {
    final url = Uri.parse('https://biz-booster.vercel.app/api/checkout/lead-by-user/$userId');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List data = jsonData['data'];
      return data.map((e) => LeadModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load leads');
    }
  }
}
