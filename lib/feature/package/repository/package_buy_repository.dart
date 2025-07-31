import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;

Future<void> initiatePayment({
  required BuildContext context,
  required double amount,
  required String customerId,
  required String customerName,
  required String customerEmail,
  required String customerPhone,
  required String orderId,
}) async {
  final url = Uri.parse("https://biz-booster.vercel.app/api/payment/generate-payment-link");

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "orderId": orderId,
        "amount": amount,
        "customerId": customerId,
        "customerName": customerName,
        "customerEmail": customerEmail,
        "customerPhone": customerPhone,
      }),
    );

    print("Response: ${response.body}");
    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["paymentLink"] != null) {
      final paymentUrl = data["paymentLink"];
      _openInAppWebView(context, paymentUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Failed to generate payment link")),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("❌ Error: $e")),
    );
  }
}


void _openInAppWebView(BuildContext context, String paymentUrl) {
  final uri = Uri.tryParse(paymentUrl);

  if (uri == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("❌ Invalid Payment URL")),
    );
    return;
  }

  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: Text("Payment Gateway")),
        body: InAppWebView(
          initialUrlRequest: URLRequest(
            url: WebUri.uri(uri), // ✅ safer conversion
          ),
          onLoadStop: (controller, url) {
            final currentUrl = url?.toString() ?? "";

            print("Current URL: $currentUrl");

            if (currentUrl.contains("success")) {
              Navigator.pop(context, true);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("✅ Payment Successful!")),
              );
            } else if (currentUrl.contains("failed") || currentUrl.contains("cancel")) {
              Navigator.pop(context, true);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("❌ Payment Failed or Cancelled")),
              );
            }
          },
        ),
      ),
    ),
  );
}
