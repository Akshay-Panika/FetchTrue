import 'dart:convert';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;


Future<bool> initiatePackagePayment({
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

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["paymentLink"] != null) {
      final paymentUrl = data["paymentLink"];
      final result = await _openInAppWebView(context, paymentUrl);
      return result;
    } else {
      showCustomSnackBar(context, 'Failed to generate payment link');
      return false;
    }
  } catch (e) {
    showCustomSnackBar(context, 'Error: $e');
    return false;
  }
}


Future<bool> _openInAppWebView(BuildContext context, String paymentUrl) async {
  final uri = Uri.tryParse(paymentUrl);
  if (uri == null) {
    showCustomSnackBar(context, 'Invalid Payment URL');
    return false;
  }

  bool isPaymentHandled = false;
  bool isPaymentSuccess = false;

  final result = await Navigator.of(context).push<bool>(
    MaterialPageRoute(
      builder: (_) => WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, isPaymentSuccess); // Pass result on back
          return false;
        },
        child: Scaffold(
          appBar: CustomAppBar(title: 'Pay Now', showBackButton: true),
          body: InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri.uri(uri)),
            onLoadStop: (controller, url) {
              final currentUrl = url?.toString() ?? "";

              if (!isPaymentHandled) {
                if (currentUrl.contains("response")) {
                  isPaymentHandled = true;
                  isPaymentSuccess = true;
                  showCustomSnackBar(context, 'Payment Successful!');
                } else if (currentUrl.contains("failed") || currentUrl.contains("cancel")) {
                  isPaymentHandled = true;
                  isPaymentSuccess = false;
                  showCustomSnackBar(context, 'Payment Failed or Cancelled');
                }
              }
            },
          ),
        ),
      ),
    ),
  );

  return result ?? false; // Default to false if null
}
