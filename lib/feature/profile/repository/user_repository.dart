
import 'package:dio/dio.dart';
import 'package:fetchtrue/feature/profile/model/user_model.dart';
import 'package:fetchtrue/helper/api_urls.dart';

class UserRepository {
  final Dio _dio = Dio();

  Future<UserModel> getUserById(String userId) async {
    try {
      final response = await _dio.get("${ApiUrls.user}/$userId");

      if (response.statusCode == 200 && response.data["success"] == true) {
        return UserModel.fromJson(response.data["data"]);
      } else {
        throw Exception(response.data["message"] ?? "Failed to load user");
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<UserModel> updateUser(String userId, Map<String, dynamic> data) async {
    try {
      final response = await _dio.patch(
        "${ApiUrls.userUpdateInfo}/$userId",
        data: data,
      );

      if (response.statusCode == 200 && response.data["success"] == true) {
        return UserModel.fromJson(response.data["data"]);
      } else {
        throw Exception(response.data["message"] ?? "Failed to update user");
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<UserModel> updateProfilePhoto(String userId, String filePath) async {
    try {
      final formData = FormData.fromMap({
        "profilePhoto": await MultipartFile.fromFile(filePath),
      });

      final response = await _dio.patch(
        "${ApiUrls.userUpdateProfile}/$userId",
        data: formData,
      );

      if (response.statusCode == 200 && response.data["success"] == true) {
        return UserModel.fromJson(response.data["data"]);
      } else {
        throw Exception(response.data["message"] ?? "Failed to update profile photo");
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }


  String _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      return "Connection timeout. Please try again.";
    } else if (e.type == DioExceptionType.receiveTimeout) {
      return "Server is not responding.";
    } else if (e.response != null) {
      return e.response?.data["message"] ?? "Something went wrong!";
    } else {
      return "Unexpected error occurred.";
    }
  }
}