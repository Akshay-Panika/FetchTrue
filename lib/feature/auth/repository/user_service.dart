import 'package:dio/dio.dart';
import 'package:fetchtrue/helper/api_urls.dart';
import '../../profile/model/user_model.dart';

class UserService {
  final Dio _dio = Dio();

  Future<UserModel?> fetchUserById(String userId) async {
    try {
      // ⚠️ Make sure userId is sent in query params or as part of URL
      final response = await _dio.get('${ApiUrls.user}/$userId');

      if (response.statusCode == 200 && response.data['success'] == true) {
        return UserModel.fromJson(response.data['data']);
      } else {
        print('API returned false: ${response.data}');
      }
    } catch (e) {
      print('Fetch Error: $e');
    }
    return null;
  }
}
