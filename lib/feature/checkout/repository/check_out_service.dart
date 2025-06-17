import 'package:dio/dio.dart';
import '../../../helper/api_helper.dart';
import '../../../helper/api_urls.dart';
import '../model/check_out_model.dart';

class CheckOutService {
  static Future<CheckoutModel?> checkOutService(CheckoutModel model) async {
    try {
      print("🚀 Request Data: ${model.toJson()}");

      final response = await ApiClient.dio.post(
        ApiUrls.checkout,
        data: model.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = response.data['data'];
        print('✅ Response: $jsonData');
        return CheckoutModel.fromJson(jsonData);
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
