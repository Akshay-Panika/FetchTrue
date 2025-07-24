import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../../core/widgets/custom_appbar.dart';

class CashfreePaymentScreen extends StatefulWidget {
  final String url;

  const CashfreePaymentScreen({super.key, required this.url});

  @override
  State<CashfreePaymentScreen> createState() => _CashfreePaymentScreenState();
}

class _CashfreePaymentScreenState extends State<CashfreePaymentScreen> {
  InAppWebViewController? webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: InAppWebView(
          initialUrlRequest: URLRequest(url: WebUri(widget.url)),
          onWebViewCreated: (controller) {
            webViewController = controller;
          },
          onLoadStop: (controller, uri) {
            final currentUrl = uri.toString();
            if (currentUrl.contains("response")) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("✅ Payment Success")),
              );
        
              Future.delayed(Duration(seconds: 3), () {Navigator.pop(context);});
            }
        
            if (currentUrl.contains("failed")) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("❌ Payment Failed")),);
              Future.delayed(Duration(seconds: 1), () {
                Navigator.pop(context); // Go back
              });
            }
          },
        ),
      ),
    );
  }
}
