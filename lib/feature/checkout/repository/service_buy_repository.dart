import 'dart:convert';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;


Future<void> initiateServicePayment({
  required BuildContext context,
  required String orderId,
  required String checkoutId,
  required double amount,
  required String customerId,
  required String name,
  required String email,
  required String phone,
  required VoidCallback onPaymentSuccess, // 👈

}) async {
  final url = Uri.parse("https://biz-booster.vercel.app/api/payment/generate-payment-link");

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "orderId": orderId,
        "checkoutId": checkoutId,
        "amount": amount,
        "customerId": customerId,
        "customerName": name,
        "customerEmail": email,
        "customerPhone": phone,
      }),
    );

    print("Response: ${response.body}");
    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["paymentLink"] != null) {
      final paymentUrl = data["paymentLink"];
      _openInAppWebView(context, paymentUrl, onPaymentSuccess);
    } else {
      showCustomSnackBar(context, 'Failed to generate payment link');
    }
  } catch (e) {
    showCustomSnackBar(context, 'Error: $e');
  }
}



void _openInAppWebView(BuildContext context, String paymentUrl, void Function() onPaymentSuccess) {
  final uri = Uri.tryParse(paymentUrl);

  if (uri == null) {
    showCustomSnackBar(context, 'Invalid Payment URL');
    return;
  }

  bool isPaymentHandled = false; // ✅ Flag to prevent multiple calls

  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => WillPopScope(
        onWillPop: () async {
          onPaymentSuccess(); // ✅ Callback on back
          return true;
        },
        child: Scaffold(
          appBar: CustomAppBar(title: 'Pay Now', showBackButton: true),
          body: InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri.uri(uri),
            ),
            onLoadStop: (controller, url) {
              if (isPaymentHandled) return;
        
              final currentUrl = url?.toString() ?? "";
        
              if (!isPaymentHandled && currentUrl.contains("response")) {
                // print("Current URL: $currentUrl");
                isPaymentHandled = true;
                showCustomSnackBar(context, 'Payment Successful!');
              } else if (currentUrl.contains("failed") || currentUrl.contains("cancel")) {
                isPaymentHandled = true;
                showCustomSnackBar(context, 'Payment Failed or Cancelled');
              }
            },
          ),
        ),
      ),
    ),
  );
}
