// my_team_repository.dart
import 'dart:convert';
import 'package:fetchtrue/helper/api_urls.dart';
import 'package:http/http.dart' as http;
import '../model/my_team_model.dart';

import 'package:dio/dio.dart';
import '../model/my_team_model.dart';

class MyTeamRepository {
  final Dio _dio = Dio();

  Future<MyTeamModel> getMyTeam(String userId) async {
    try {
      final response = await _dio.get(
        "${ApiUrls.myTeam}/$userId",
      );

      if (response.statusCode == 200) {
        return MyTeamModel.fromJson(response.data);
      } else {
        throw Exception("Failed to load team data");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}


// class MyTeamRepository {
//   final String baseUrl = "https://biz-booster.vercel.app/api/team-build/my-team";
//
//   Future<MyTeamModel> getMyTeam(String userId) async {
//     final response = await http.get(Uri.parse('$baseUrl/$userId'));
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       return MyTeamModel.fromJson(data);
//     } else {
//       throw Exception('Failed to load My Team');
//     }
//   }
// }
