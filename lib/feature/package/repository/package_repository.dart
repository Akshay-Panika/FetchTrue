import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/package_model.dart';

class PackageRepository {
  static Future<List<PackageModel>> getPackages() async {
    final response = await http.get(
      Uri.parse("https://biz-booster.vercel.app/api/packages"),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data is List) {
        return data.map((item) => PackageModel.fromJson(item as Map<String, dynamic>)).toList();
      } else if (data is Map) {
        return [PackageModel.fromJson(data as Map<String, dynamic>)];
      }
    }
    throw Exception("Failed to load packages");
  }
}
