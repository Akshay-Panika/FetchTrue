import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/retting_and_reviews_model.dart';

class ReviewService {
  Future<ReviewResponse?> fetchReviews(String serviceId) async {
    final url = Uri.parse('https://biz-booster.vercel.app/api/service/review/$serviceId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return ReviewResponse.fromJson(jsonData);
      }
    } catch (e) {
      print("Error fetching reviews: $e");
    }
    return null;
  }
}
