import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CashfreePaymentUIScreen extends StatefulWidget {
  const CashfreePaymentUIScreen({super.key});

  @override
  State<CashfreePaymentUIScreen> createState() =>
      _CashfreePaymentUIScreenState();
}

class _CashfreePaymentUIScreenState extends State<CashfreePaymentUIScreen> {
  final TextEditingController _amountController = TextEditingController();

  // Replace with your test Cashfree Payment Link
  final String basePaymentUrl = "https://payments.cashfree.com/forms/YOUR_FORM_ID";

  void _startPayment() {
    final enteredAmount = _amountController.text.trim();
    if (enteredAmount.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Please enter amount")),
      );
      return;
    }

    // If your Cashfree link supports pre-filled amount via query param
    final paymentUrl = "$basePaymentUrl?amount=$enteredAmount";

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CashfreeWebViewScreen(paymentUrl: paymentUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Amount")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Enter Amount",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _startPayment,
              icon: const Icon(Icons.payment),
              label: const Text("Proceed to Pay"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CashfreeWebViewScreen extends StatefulWidget {
  final String paymentUrl;
  const CashfreeWebViewScreen({super.key, required this.paymentUrl});

  @override
  State<CashfreeWebViewScreen> createState() => _CashfreeWebViewScreenState();
}

class _CashfreeWebViewScreenState extends State<CashfreeWebViewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cashfree Payment")),
      body: WebViewWidget(controller: _controller),
    );
  }
}
