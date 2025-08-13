import 'dart:convert';
import 'package:http/http.dart' as http;

import '../ads/model/add_model.dart';


class AdsRepository {
  final String baseUrl = 'https://biz-booster.vercel.app/api/ads';

  Future<AdsModel> fetchAds() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return AdsModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to load ads');
    }
  }
}
