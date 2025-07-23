import 'package:flutter/material.dart';

import '../../checkout/repository/payment_gateway_service.dart';

class AmountScreen extends StatefulWidget {
  const AmountScreen({Key? key}) : super(key: key);

  @override
  State<AmountScreen> createState() => _AmountScreenState();
}

class _AmountScreenState extends State<AmountScreen> {
  final TextEditingController _amountController = TextEditingController();

  void _startPayment() {
    final amountText = _amountController.text.trim();
    if (amountText.isEmpty || int.tryParse(amountText) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid amount')),
      );
      return;
    }

    final int amount = int.parse(amountText);

    // Call payment function
    generateCashFreeLink(
      context,
      amount: amount,
      customerId: "123456",
      name: "Akshay",
      email: "akshay@example.com",
      phone: "9999999999",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Amount')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter Amount',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startPayment,
              child: const Text('Pay Now'),
            ),
          ],
        ),
      ),
    );
  }
}
