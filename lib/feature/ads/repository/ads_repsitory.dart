import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/add_model.dart';

class AdsService {
  static Future<List<AdData>> getAds() async {
    const url = 'https://biz-booster.vercel.app/api/ads';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final adsModel = AdsModel.fromJson(jsonData);
      return adsModel.data;
    } else {
      throw Exception('Failed to fetch ads');
    }
  }
}
