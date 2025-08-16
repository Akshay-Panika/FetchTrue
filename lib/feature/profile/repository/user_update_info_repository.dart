
import 'package:dio/dio.dart';
import 'package:fetchtrue/feature/profile/model/user_model.dart';
import 'package:fetchtrue/helper/api_urls.dart';

class UserUpdateInfoRepository {
  final Dio _dio = Dio();

  Future<UserModel?> updateUser(String userId, Map<String, dynamic> data)async{
    try{
      final response = await _dio.patch(
          '${ApiUrls.userUpdateInfo}/$userId',
           data: data,
      );

     //  if(response.statusCode == 200 && response.data['success'] == true){
     //   return UserModel.fromJson(response.data['data']);
     // }
     // else{
     //   return null;
     // }
      return UserModel.fromJson(response.data);

    }  on DioException catch (error){
      throw Exception('Dio error: ${error.message}');
    }

    catch (error){
      throw Exception('Unexpected error: $error');
    }

  }
}