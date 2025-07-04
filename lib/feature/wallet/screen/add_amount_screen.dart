import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController nameController = TextEditingController(text: "Mansi Sharma");
  final TextEditingController emailController = TextEditingController(text: "mansi@example.com");
  final TextEditingController phoneController = TextEditingController(text: "9999999999");
  final TextEditingController amountController = TextEditingController(text: "10059");

  bool isLoading = false;

  Future<void> generatePaymentLink() async {
    final url = Uri.parse('https://biz-booster.vercel.app/api/payment/generate-payment-link');

    final body = {
      "amount": int.tryParse(amountController.text) ?? 0,
      "customerId": "cust001", // You can dynamically assign
      "customerName": nameController.text.trim(),
      "customerEmail": emailController.text.trim(),
      "customerPhone": phoneController.text.trim(),
    };

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final paymentLink = data['paymentLink'];

        if (paymentLink != null && paymentLink is String) {
          launchUrl(Uri.parse(paymentLink), mode: LaunchMode.externalApplication);
        } else {
          _showSnackBar('Payment link not found.');
        }
      } else {
        _showSnackBar('Failed: ${response.statusCode}');
      }
    } catch (e) {
      _showSnackBar('Error: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Payment Generator")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildField("Customer Name", nameController),
            _buildField("Email", emailController),
            _buildField("Phone", phoneController, keyboardType: TextInputType.phone),
            _buildField("Amount", amountController, keyboardType: TextInputType.number),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: isLoading
                  ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                  : const Icon(Icons.payment),
              label: Text(isLoading ? "Processing..." : "Generate Payment Link"),
              onPressed: isLoading ? null : generatePaymentLink,
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, {TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
