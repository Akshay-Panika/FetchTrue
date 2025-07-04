import 'dart:convert';

import 'package:flutter/cupertino.dart';
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
        await launchUrl(Uri.parse(paymentLink), mode: LaunchMode.externalApplication);
      } else {
        showCustomSnackBar(context, 'Payment link not received.');
      }
    } else {
      showCustomSnackBar(context, 'Failed to generate payment link: ${response.statusCode}');
    }
  } catch (e) {
    showCustomSnackBar(context, 'Error: $e');
  }
}