import 'package:dio/dio.dart';
import '../../../helper/api_urls.dart';
import '../model/add_customer_model.dart';
import '../../../helper/api_helper.dart';

class AddCustomerService {
  static Future<AddCustomerModel?> createCustomer(AddCustomerModel model) async {
    try {

      print("🚀 Request Data: ${model.toJson()}");

      final formData = FormData.fromMap(model.toJson());
      // final formData = FormData.fromMap(data);
      final response = await ApiClient.dio.post(
        ApiUrls.serviceCustomer,
        data: formData, // send as JSON
        // data: model.toJson(),
        options: Options(
          headers: {
            // 'Content-Type': 'application/json',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = response.data['data'];
        print('✅ Response: $jsonData');

        return AddCustomerModel.fromJson(jsonData);
      } else {
        print('❌ Invalid response: ${response.data}');
        return null;
      }
    } on DioException catch (e) {
      final errorMsg = e.response?.data ?? e.message;
      print('❌ DioException: $errorMsg');
      return null;
    } catch (e) {
      print('❌ Unexpected error: $e');
      return null;
    }
  }
}

