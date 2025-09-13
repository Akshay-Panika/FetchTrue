
import 'package:dio/dio.dart';
import '../../../helper/api_client.dart';
import '../../../helper/api_urls.dart';
import '../model/customer_model.dart';

class CustomerService {
  final Dio _dio = OldApiClient.dio;


  Future<List<CustomerModel>> fetchCustomer() async {
    try {
      final response = await _dio.get(ApiUrls.serviceCustomer);

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => CustomerModel.fromJson(json)).toList();
      } else {
        throw Exception('Invalid response format or status: ${response.statusCode}');
      }
    }
    on DioException catch (e) {
      final errorMsg = e.response?.data ?? e.message;
      throw Exception('Dio error: $errorMsg');
    }
    catch (e) {
      throw Exception('Unexpected error in fetching service customer: $e');
    }
  }
}