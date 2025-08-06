import 'dart:convert';
import 'package:fetchtrue/feature/advisers/model/advisor_model.dart';
import 'package:http/http.dart' as http;

class AdvisorService {
  static const String baseUrl = 'https://biz-booster.vercel.app/api/advisor';

  Future<List<AdvisorModel>> fetchAdvisors() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final List<dynamic> data = jsonData['data'];

      return data.map((json) => AdvisorModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load advisors');
    }
  }
}
