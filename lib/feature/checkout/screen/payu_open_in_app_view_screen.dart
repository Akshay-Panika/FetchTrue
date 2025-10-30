import 'package:fetchtrue/core/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher_string.dart';


void openInAppWebView(
    BuildContext context, String paymentUrl, VoidCallback onPaymentSuccess) {
  final uri = Uri.tryParse(paymentUrl);

  if (uri == null) {
    showCustomSnackBar(context, 'Invalid Payment URL');
    return;
  }

  bool isPaymentHandled = false;

  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => WillPopScope(
          onWillPop: () async {
            // Back pressed -> just pop the screen
            if (!isPaymentHandled) {
              isPaymentHandled = true;
              onPaymentSuccess();
            }
            return true; // allow pop
          },
          child: Scaffold(
            body: SafeArea(
              child: InAppWebView(
                initialUrlRequest: URLRequest(url: WebUri.uri(uri)),
                initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                    javaScriptEnabled: true,
                    useShouldOverrideUrlLoading: true,
                  ),
                ),
                onLoadStop: (controller, url) async {
                  final currentUrl = url?.toString() ?? "";

                  if (!isPaymentHandled && currentUrl.contains("response")) {
                    isPaymentHandled = true;
                    onPaymentSuccess();
                    Navigator.pop(context); // close screen after success
                  } else if (currentUrl.contains("failed") ||
                      currentUrl.contains("cancel")) {
                    isPaymentHandled = true;
                    Navigator.pop(context);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      showCustomSnackBar(context, 'Payment Failed or Cancelled');
                    });
                  }
                },
                shouldOverrideUrlLoading:
                    (controller, navigationAction) async {
                  final url = navigationAction.request.url?.toString() ?? "";

                  // UPI Intent handling
                  if (url.startsWith("upi://")) {
                    try {
                      await launchUrlString(url,
                          mode: LaunchMode.externalApplication);
                    } catch (e) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        showCustomSnackBar(context, "UPI app not found");
                      });
                    }
                    return NavigationActionPolicy.CANCEL;
                  }

                  // Allow all HTTP/HTTPS URLs
                  return NavigationActionPolicy.ALLOW;
                },
                onReceivedError: (controller, request, error) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    showCustomSnackBar(context,
                        "Error loading URL: ${request.url}, ${error.description}");
                  });
                },
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
