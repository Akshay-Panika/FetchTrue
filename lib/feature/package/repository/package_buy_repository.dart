import 'package:dio/dio.dart';
import 'package:fetchtrue/core/costants/custom_log_emoji.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../helper/api_client.dart';

final ApiClient _apiClient = ApiClient();

Future<bool> packageBuyPaymentRepository({
  required BuildContext context,
  required num amount,
  required String customerId,
  required String customerName,
  required String customerEmail,
  required String customerPhone,
  // required String orderId,
}) async {
  try {
    final response = await _apiClient.post(
      "https://api.fetchtrue.com/api/payments/create-smepay-order",
      data: {
        "amount": amount,
        "customerId": customerId,
        "customer_details": {
          "name": customerName,
          "email": customerEmail,
          "phone": customerPhone,
        }
      },
    );

    final data = response.data;
    final paymentUrl = data["paylink"];
    final orderSlug = data["order_slug"]; // 👈 verify के लिए इस्तेमाल होगा

    if (response.statusCode == 200 && paymentUrl != null) {
      final result = await _openInAppWebView(context, paymentUrl, orderSlug);
      return result;
    } else {
      debugPrint(
        "${CustomLogEmoji.error} Package Payment Failed to Generate Payment Link: "
            "${response.statusCode} -> ${response.data}",
      );
      return false;
    }
  } on DioException catch (e) {
    if (e.response != null) {
      print("${CustomLogEmoji.error} Package Payment API Error "
          "[${e.response?.statusCode}]: ${e.response?.data}");
    } else {
      print("${CustomLogEmoji.error} Package Payment Network Error: ${e.message}");
    }
    rethrow;
  }
}

Future<bool> _openInAppWebView(
    BuildContext context,
    String paymentUrl,
    String orderSlug,
    ) async {
  final uri = Uri.tryParse(paymentUrl);
  if (uri == null) {
    showCustomToast('Invalid Payment URL');
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
          // appBar: CustomAppBar(title: 'Pay Now', showBackButton: true),
          body: InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri.uri(uri)),
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              final url = navigationAction.request.url.toString();
              final uri = Uri.tryParse(url);

              if (uri != null) {
                const upiSchemes = ['upi', 'tez', 'phonepe', 'paytm', 'gpay'];

                if (upiSchemes.contains(uri.scheme)) {
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } else {
                    showCustomToast("UPI app not installed");
                  }
                  return NavigationActionPolicy.CANCEL;
                }
              }

              // Payment webhook / success URL ko allow karo, WebView me hi process ho
              if (url.contains("smepay-webhook") || url.contains("response") || url.contains("success") || url.contains("failed")) {
                return NavigationActionPolicy.ALLOW;
              }

              return NavigationActionPolicy.ALLOW;
            },
              onLoadStop: (controller, url) async {
                final currentUrl = url?.toString() ?? "";
                if (!isPaymentHandled) {
                  if (currentUrl.contains("smepay-webhook") || currentUrl.contains("response") || currentUrl.contains("success")) {
                    isPaymentHandled = true;

                    // Backend verify
                    try {
                      final verifyResponse = await _apiClient.post(
                        "https://api.fetchtrue.com/api/payments/verify-order",
                        data: {"order_slug": orderSlug},
                      );

                      if (verifyResponse.data["status"] == true) {
                        isPaymentSuccess = true;
                        showCustomToast('Payment Successful ✅');
                      } else {
                        isPaymentSuccess = false;
                        showCustomToast('Payment verification फेल ❌');
                      }
                    } catch (e) {
                      isPaymentSuccess = false;
                      showCustomToast('Payment Verification Error ❌');
                    }

                    // WebView close karna
                    Navigator.pop(context, isPaymentSuccess);
                  } else if (currentUrl.contains("failed") || currentUrl.contains("cancel")) {
                    isPaymentHandled = true;
                    isPaymentSuccess = false;
                    showCustomToast('Payment Failed or Cancelled ❌');
                    Navigator.pop(context, isPaymentSuccess);
                  }
                }
              }

          ),
        ),
      ),
    ),
  );

  return result ?? false;
}

