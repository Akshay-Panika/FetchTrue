import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/leads_model.dart'; // make sure this is correct

class LeadByUserService {
  static Future<LeadsModel?> fetchCheckoutById(String userId, String checkoutId) async {
    final apiUrl = 'https://biz-booster.vercel.app/api/checkout/lead-by-user/$userId';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> dataList = jsonData['data'];

        for (var item in dataList) {
          if (item['_id'] == checkoutId) {
            return LeadsModel.fromJson(item); // ✅ Map to LeadsModel
          }
        }
        return null;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching checkout: $e');
      return null;
    }
  }
}
