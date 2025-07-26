import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/offer_model.dart';

class OfferService {
  static Future<List<OfferModel>> fetchOffers() async {
    final response = await http.get(Uri.parse("https://biz-booster.vercel.app/api/offer"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List offers = data["data"];
      return offers.map((e) => OfferModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load offers");
    }
  }
}
