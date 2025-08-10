import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/understanding_fetch_true_model.dart';

class UnderstandingFetchTrueService {
  static const String _baseUrl =
      "https://biz-booster.vercel.app/api/academy/understandingfetchtrue";

  static Future<UnderstandingFetchTrueModel> fetchData() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      return UnderstandingFetchTrueModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load data: ${response.statusCode}");
    }
  }
}
