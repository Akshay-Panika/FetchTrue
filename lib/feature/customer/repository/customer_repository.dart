import 'package:dio/dio.dart';
import '../../../helper/api_client.dart';
import '../model/add_customer_model.dart';
import '../../../helper/api_urls.dart';
import '../model/customer_model.dart';

class CustomerRepository {
  static final _dio = OldApiClient.dio;

  /// Create a new customer
  static Future<AddCustomerModel?> createCustomer(AddCustomerModel model) async {
    try {
      final response = await _dio.post(
        ApiUrls.serviceCustomer,
        data: FormData.fromMap(model.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AddCustomerModel.fromJson(response.data['data']);
      }
    } on DioException catch (e) {
      print('Dio error: ${e.response?.data ?? e.message}');
    } catch (e) {
      print('Unexpected error: $e');
    }
    return null;
  }

  /// Fetch all customers
  static Future<List<CustomerModel>> fetchCustomer() async {
    try {
      final response = await _dio.get(ApiUrls.serviceCustomer);

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => CustomerModel.fromJson(json)).toList();
      } else {
        throw Exception('Invalid response or status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      final errorMsg = e.response?.data ?? e.message;
      throw Exception('Dio error: $errorMsg');
    } catch (e) {
      throw Exception('Unexpected error in fetching customers: $e');
    }
  }
}
