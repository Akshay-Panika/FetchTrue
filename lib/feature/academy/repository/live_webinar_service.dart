import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/live_webinar_model.dart'; // Adjust the import path

class LiveWebinarService {
  final String baseUrl = 'https://biz-booster.vercel.app/api/academy/livewebinars'; // Replace with your actual endpoint

  Future<LiveWebinarModel?> fetchLiveWebinars() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return LiveWebinarModel.fromJson(jsonData);
      } else {
        print('Failed to load webinars: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching webinars: $e');
      return null;
    }
  }
}
