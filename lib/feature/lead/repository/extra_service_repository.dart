import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/extra_service_model.dart';

class ExtraServiceRepository {
  Future<List<ExtraServiceModel>> fetchExtraServices(String checkoutId) async {
    final url = Uri.parse(
        'https://api.fetchtrue.com/api/leads/FindByCheckout/$checkoutId');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData['success'] == true &&
          jsonData['data']['extraService'] != null) {
        final List<dynamic> extraServices =
        jsonData['data']['extraService'] as List<dynamic>;
        return extraServices
            .map((e) => ExtraServiceModel.fromJson(e))
            .toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load Extra Services');
    }
  }
}
