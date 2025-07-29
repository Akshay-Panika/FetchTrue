import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/address_model.dart';

class AddressService {
  static Future<bool> updateUserAddress(String userId, AddressModel model) async {
    final uri = Uri.parse('https://biz-booster.vercel.app/api/users/add-address/$userId');

    try {
      final response = await http.patch(
        uri,
        headers: {
          "Content-Type": "application/json",
          // "Authorization": "Bearer YOUR_TOKEN_HERE", // Optional
        },
        body: jsonEncode(model.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed: ${response.statusCode}');
        print('Body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception: $e');
      return false;
    }
  }
}
