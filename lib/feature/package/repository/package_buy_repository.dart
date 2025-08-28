import 'package:dio/dio.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

final dio = Dio();

Future<bool> packageBuyPaymentRepository({
  required BuildContext context,
  required double amount,
  required String customerId,
  required String customerName,
  required String customerEmail,
  required String customerPhone,
  required String orderId,
}) async {
  try {
    final response = await dio.post(
      "https://biz-booster.vercel.app/api/payment/generate-payment-link",
      data: {
        "orderId": orderId,
        "amount": amount,
        "customerId": customerId,
        "customerName": customerName,
        "customerEmail": customerEmail,
        "customerPhone": customerPhone,
      },
      options: Options(headers: {"Content-Type": "application/json"}),
    );

    final data = response.data;

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
          Navigator.pop(context, isPaymentSuccess);
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
                } else if (currentUrl.contains("failed") ||
                    currentUrl.contains("cancel")) {
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

  return result ?? false;
}
