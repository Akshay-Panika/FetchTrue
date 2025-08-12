import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/commission_model.dart';

class CommissionService {
  static Future<CommissionModel?> fetchCommission() async {
    try {
      final response = await http.get(
        Uri.parse('https://biz-booster.vercel.app/api/commission'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        if (jsonList.isNotEmpty) {
          return CommissionModel.fromJson(jsonList[0]);
        }
      } else {
        throw Exception('Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Exception in fetchCommission: $e');
    }
    return null;
  }
}
