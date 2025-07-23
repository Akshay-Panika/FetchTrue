// import 'dart:convert';
// import 'package:fetchtrue/helper/api_urls.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:http/http.dart' as http;
//
// class AddAmountScreen extends StatefulWidget {
//   const AddAmountScreen({super.key});
//   @override
//   State<AddAmountScreen> createState() => _AddAmountScreenState();
// }
//
// class _AddAmountScreenState extends State<AddAmountScreen> {
//   final TextEditingController _amountController = TextEditingController();
//   InAppWebViewController? webViewController;
//
//   // 🛡️ Use your actual sandbox credentials
//   final String clientId = '${ApiUrls.Client_id}';  // Replace with your sandbox client ID
//   final String clientSecret = '${ApiUrls.Client_secret}';  // Replace with your sandbox secret
//
//   Future<void> createOrder(String amount) async {
//     final url = Uri.parse('https://sandbox.cashfree.com/pg/orders');
//     final headers = {
//       'Content-Type': 'application/json',
//       'x-client-id': clientId,
//       'x-client-secret': clientSecret,
//     };
//
//     final orderId = "order_${DateTime.now().millisecondsSinceEpoch}";
//     final body = jsonEncode({
//       "order_id": orderId,
//       "order_amount": double.parse(amount),
//       "order_currency": "INR",
//       "customer_details": {
//         "customer_id": "123456",
//         "customer_email": "test@cashfree.com",
//         "customer_phone": "9876543210"
//       }
//     });
//
//     final response = await http.post(url, headers: headers, body: body);
//     final jsonData = json.decode(response.body);
//
//     if (response.statusCode == 200 && jsonData["payment_link"] != null) {
//       openWebView(jsonData["payment_link"]);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("❌ Order Failed: ${jsonData['message'] ?? 'Unknown Error'}")),
//       );
//     }
//   }
//
//   void openWebView(String url) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => AlertDialog(
//         content: SizedBox(
//           height: 500,
//           child: InAppWebView(
//             initialUrlRequest: URLRequest(url: WebUri(url)),
//             onWebViewCreated: (controller) {
//               webViewController = controller;
//             },
//             onLoadStop: (controller, uri) {
//               final currentUrl = uri.toString();
//               if (currentUrl.contains("success")) {
//                 Navigator.pop(context);
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text("✅ Payment Success")),
//                 );
//               } else if (currentUrl.contains("failed")) {
//                 Navigator.pop(context);
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text("❌ Payment Failed")),
//                 );
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _amountController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Add Amount")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _amountController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 labelText: "Enter Amount",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 final amount = _amountController.text.trim();
//                 if (amount.isNotEmpty) {
//                   createOrder(amount);
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text("Please enter an amount")),
//                   );
//                 }
//               },
//               child: Text("Proceed to Pay"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
