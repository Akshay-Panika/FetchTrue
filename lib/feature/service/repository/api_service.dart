

import 'package:bizbooster2x/feature/service/model/service_model.dart';
import 'package:bizbooster2x/helper/api_urls.dart';
import 'package:dio/dio.dart';

class ApiService{
  final Dio _dio = Dio();

  Future<List<ServiceModel>> fetchServices() async{
    try{
      final response = await _dio.get(ApiUrls.modulesService);

      if(response.statusCode == 200 && response.data['success'] == true){
        final List<dynamic> data = response.data['data'];
        return data.map((json) => ServiceModel.fromJson(json)).toList();
      }
      else{
        throw Exception('Server returned error: ${response.statusMessage}');
      }
    }

    catch (e){
      throw Exception('API Error: $e');
    }
  }
}

