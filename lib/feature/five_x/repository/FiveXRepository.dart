import 'package:dio/dio.dart';
import '../model/FiveXModel.dart';

class FiveXRepository {
  final Dio dio = Dio();

  Future<List<FiveXModel>> fetchFiveXData() async {
    try {
      final response = await dio.get('https://api.fetchtrue.com/api/fivex');

      if (response.statusCode == 200) {
        final data = response.data as List;
        return data.map((json) => FiveXModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
