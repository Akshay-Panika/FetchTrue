// file: lib/feature/checkout/repository/check_out_service.dart
import 'package:dio/dio.dart';

class PaymentGatewayService {
  static const _baseUrlSandbox = 'https://sandbox.cashfree.com/pg/orders';
  static const appId = 'YOUR_APP_ID';
  static const secretKey = 'YOUR_SECRET_KEY';

  static Future<String> createCashfreeOrder({
    required String orderId,
    required double amount,
    required String phone,
    required String email,
  }) async {
    final dio = Dio();
    final resp = await dio.post(
      _baseUrlSandbox,
      options: Options(headers: {
        'x-client-id': appId,
        'x-client-secret': secretKey,
        'Content-Type': 'application/json',
      }),
      data: {
        "order_id": orderId,
        "order_amount": amount,
        "order_currency": "INR",
        "customer_details": {
          "customer_id": phone,
          "customer_email": email,
          "customer_phone": phone,
        }
      },
    );
    if (resp.statusCode == 200) {
      return resp.data['payment_session_id'];
    } else {
      throw Exception('Cashfree order creation failed');
    }
  }
}
