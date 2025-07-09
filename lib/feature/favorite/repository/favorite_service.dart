import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/favorite_services_model.dart';

Future<FavoriteServicesModel?> fetchFavoriteServices(String userId) async {
  final url = Uri.parse('https://biz-booster.vercel.app/api/users/$userId');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      return FavoriteServicesModel.fromJson(jsonBody);
    } else {
      print("Failed to load: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("Error: $e");
    return null;
  }
}
