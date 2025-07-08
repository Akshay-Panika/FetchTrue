import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/recorded_webinar_model.dart'; // Adjust path as per your folder structure

class RecordedWebinarService {
  final String baseUrl = 'https://biz-booster.vercel.app/api/academy/webinars'; // Replace with your actual API URL

  Future<RecordedWebinarModel?> fetchRecordedWebinars() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return RecordedWebinarModel.fromJson(jsonData);
      } else {
        print('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }
}
