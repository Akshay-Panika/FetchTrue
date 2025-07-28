import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../core/widgets/custom_snackbar.dart';
import '../screen/cashfree_payment_screen.dart';

// Future<void> cashFreeService(
//     BuildContext context, {
//       required int amount,
//       required String customerId,
//       required String name,
//       required String email,
//       required String phone,
//       required VoidCallback onPaymentSuccess,
//
//     }) async {
//   final url = Uri.parse('https://biz-booster.vercel.app/api/payment/generate-payment-link');
//   final body = {
//     "amount": amount,
//     "customerId": customerId,
//     "customerName": name,
//     "customerEmail": email,
//     "customerPhone": phone,
//   };
//
//   final response = await http.post(
//     url,
//     headers: {"Content-Type": "application/json"},
//     body: jsonEncode(body),
//   );
//
//   if (response.statusCode == 200) {
//     final data = jsonDecode(response.body);
//     final paymentLink = data['paymentLink'];
//     if (paymentLink != null) {
//       Navigator.push(
//         context, MaterialPageRoute(builder: (_) => CashfreePaymentScreen(
//           url: paymentLink,
//           onPaymentSuccess: onPaymentSuccess,
//       )),
//       );
//     } else {
//       showCustomSnackBar(context, 'Payment link not received.');
//     }
//   } else {
//     showCustomSnackBar(context, 'Failed to generate payment link.');
//   }
// }


Future<bool> cashFreeService(
    BuildContext context, {
      required int amount,
      required String customerId,
      required String name,
      required String email,
      required String phone,
      required VoidCallback onPaymentSuccess,
    }) async {
  final url = Uri.parse('https://biz-booster.vercel.app/api/payment/generate-payment-link');
  final body = {
    "amount": amount,
    "customerId": customerId,
    "customerName": name,
    "customerEmail": email,
    "customerPhone": phone,
  };

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(body),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final paymentLink = data['paymentLink'];
    if (paymentLink != null) {
      final result = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (_) => CashfreePaymentScreen(
            url: paymentLink,
            onPaymentSuccess: onPaymentSuccess,
          ),
        ),
      );
      return result == true;
    } else {
      showCustomSnackBar(context, 'Payment link not received.');
    }
  } else {
    showCustomSnackBar(context, 'Failed to generate payment link.');
  }

  return false; // Default: fail
}
