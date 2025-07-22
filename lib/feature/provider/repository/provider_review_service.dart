import 'dart:convert';
import 'package:fetchtrue/feature/provider/model/provider_review_model.dart';
import 'package:http/http.dart' as http;

class ProviderReviewService {
  Future<ProviderReviewResponse?> fetchReviews(String providerId) async {
    final url = Uri.parse('https://biz-booster.vercel.app/api/provider/review/$providerId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return ProviderReviewResponse.fromJson(jsonData);
      }
    } catch (e) {
      print("Error fetching reviews: $e");
    }
    return null;
  }
}
