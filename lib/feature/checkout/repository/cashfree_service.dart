import 'package:dio/dio.dart';

Future<String> createCashfreeOrder() async {
  var dio = Dio();
  final response = await dio.post(
    'https://sandbox.cashfree.com/pg/orders',
    options: Options(headers: {
      'x-client-id': 'YOUR_APP_ID',
      'x-client-secret': 'YOUR_SECRET_KEY',
      'Content-Type': 'application/json',
    }),
    data: {
      "order_id": "ORDER12345",
      "order_amount": 100.00,
      "order_currency": "INR",
      "customer_details": {
        "customer_id": "cust_123",
        "customer_email": "test@example.com",
        "customer_phone": "9999999999"
      }
    },
  );

  if (response.statusCode == 200) {
    return response.data['payment_session_id'];
  } else {
    throw Exception("Failed to create order");
  }
}
