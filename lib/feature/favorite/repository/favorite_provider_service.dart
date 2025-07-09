import 'dart:convert';
import 'package:fetchtrue/feature/favorite/model/favorite_provider_model.dart';
import 'package:http/http.dart' as http;

Future<FavoriteProviderModel?> fetchFavoriteProvider(String userId) async {
  final url = Uri.parse('https://biz-booster.vercel.app/api/users/$userId');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      return FavoriteProviderModel.fromJson(jsonBody);
    } else {
      print("Failed to load: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("Error: $e");
    return null;
  }
}
