import 'package:dio/dio.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

final dio = Dio();

Future<bool> initiateCheckoutServicePayment({
  required BuildContext context,
  required String orderId,
  required String checkoutId,
  required double amount,
  required String customerId,
  required String name,
  required String email,
  required String phone,
}) async {
  try {
    final res = await dio.post(
      "https://biz-booster.vercel.app/api/payment/generate-payment-link",
      data: {
        "orderId": orderId,
        "checkoutId": checkoutId,
        "amount": amount,
        "customerId": customerId,
        "customerName": name,
        "customerEmail": email,
        "customerPhone": phone,
      },
    );

    final link = res.data?["paymentLink"];
    if (res.statusCode == 200 && link != null) {
      return await _openInAppWebView(context, link);
    } else {
      showCustomSnackBar(context, 'Failed to generate payment link');
      return false;
    }
  } catch (e) {
    showCustomSnackBar(context, 'Error: $e');
    return false;
  }
}

Future<bool> _openInAppWebView(BuildContext context, String url) async {
  final uri = Uri.tryParse(url);
  if (uri == null) {
    showCustomSnackBar(context, 'Invalid Payment URL');
    return false;
  }

  bool handled = false, success = false;

  final result = await Navigator.of(context).push<bool>(
    MaterialPageRoute(
      builder: (_) => WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, success);
          return false;
        },
        child: Scaffold(
          appBar: CustomAppBar(title: 'Pay Now', showBackButton: true),
          body: InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri.uri(uri)),
            onLoadStop: (c, u) {
              final current = u?.toString() ?? "";
              if (!handled) {
                if (current.contains("response")) {
                  handled = true;
                  success = true;
                  showCustomSnackBar(context, 'Payment Successful!');
                } else if (current.contains("failed") ||
                    current.contains("cancel")) {
                  handled = true;
                  success = false;
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


// final dio = Dio();
//
// Future<bool> initiateCheckoutServicePayment({
//   required BuildContext context,
//   required String orderId,
//   required String checkoutId,
//   required double amount,
//   required String customerId,
//   required String name,
//   required String email,
//   required String phone,
// }) async {
//   try {
//     final res = await dio.post(
//       "https://biz-booster.vercel.app/api/payment/generate-payment-link",
//       data: {
//         "orderId": orderId,
//         "checkoutId": checkoutId,
//         "amount": amount,
//         "customerId": customerId,
//         "customerName": name,
//         "customerEmail": email,
//         "customerPhone": phone,
//       },
//     );
//
//     final link = res.data?["paymentLink"];
//     if (res.statusCode == 200 && link != null) {
//       return await _openInAppWebView(context, link);
//     } else {
//       showCustomSnackBar(context, 'Failed to generate payment link');
//       return false;
//     }
//   } catch (e) {
//     showCustomSnackBar(context, 'Error: $e');
//     return false;
//   }
// }
//
// Future<bool> _openInAppWebView(BuildContext context, String url) async {
//   final uri = Uri.tryParse(url);
//   if (uri == null) {
//     showCustomSnackBar(context, 'Invalid Payment URL');
//     return false;
//   }
//
//   bool handled = false, success = false;
//
//   final result = await Navigator.of(context).push<bool>(
//     MaterialPageRoute(
//       builder: (_) => WillPopScope(
//         onWillPop: () async {
//           Navigator.pop(context, success);
//           return false;
//         },
//         child: Scaffold(
//           appBar: CustomAppBar(title: 'Pay Now', showBackButton: true),
//           body: InAppWebView(
//             initialUrlRequest: URLRequest(url: WebUri.uri(uri)),
//             onLoadStop: (c, u) {
//               final current = u?.toString() ?? "";
//               if (!handled) {
//                 if (current.contains("response")) {
//                   handled = true;
//                   success = true;
//                   showCustomSnackBar(context, 'Payment Successful!');
//                 } else if (current.contains("failed") ||
//                     current.contains("cancel")) {
//                   handled = true;
//                   success = false;
//                   showCustomSnackBar(context, 'Payment Failed or Cancelled');
//                 }
//               }
//             },
//           ),
//         ),
//       ),
//     ),
//   );
//
//   return result ?? false;
// }
