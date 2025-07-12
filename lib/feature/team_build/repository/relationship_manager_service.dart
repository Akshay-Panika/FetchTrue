import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/relationship_manager_model.dart';

class RelationshipManagerService {
  final String baseUrl = 'https://biz-booster.vercel.app/api/users';

  Future<RelationshipManagerModel?> fetchUserById(String userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$userId'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        if (jsonData['success'] == true) {
          return RelationshipManagerModel.fromJson(jsonData['data']);
        }
      } else {
        print('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('HTTP Exception: $e');
    }
    return null;
  }
}
