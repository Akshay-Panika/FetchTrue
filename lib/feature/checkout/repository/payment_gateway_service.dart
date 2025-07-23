import 'dart:convert';

import 'package:fetchtrue/feature/checkout/widget/payment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../../core/widgets/custom_snackbar.dart';

Future<void> generateCashFreeLink(BuildContext context,{
  required int amount,
  required String customerId,
  required String name,
  required String email,
  required String phone,
}) async {
  final url = Uri.parse('https://biz-booster.vercel.app/api/payment/generate-payment-link');
  final body = {
    "amount": amount,
    "customerId": customerId,
    "customerName": name,
    "customerEmail": email,
    "customerPhone": phone,
  };

  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final paymentLink = data['paymentLink'];
      if (paymentLink != null) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentScreen(url: paymentLink)));
      } else {
        showCustomSnackBar(context, 'Payment link not received.');
      }
    } else {
      showCustomSnackBar(context, 'Failed to generate payment link: ${response.statusCode}');
    }
  } catch (e) {
    showCustomSnackBar(context, 'Error: $e');
  }

  void openWebView(String url) {
    InAppWebViewController? webViewController;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        content: SizedBox(
          height: 500,
          child: InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(url)),
            onWebViewCreated: (controller) {
              webViewController = controller;
            },
            onLoadStop: (controller, uri) {
              final currentUrl = uri.toString();
              if (currentUrl.contains("response")) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("✅ Payment Success")),
                );
              } else if (currentUrl.contains("failed")) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("❌ Payment Failed")),
                );
              }
            },
          ),
        ),
      ),
    );
  }


}