import 'package:bizbooster2x/core/widgets/custom_container.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> cartItems = [
    {
      'title': 'Product 1',
      'price': 120.0,
      'image': Icons.phone_android,
      'qty': 1,
    },
    {
      'title': 'Product 2',
      'price': 80.0,
      'image': Icons.headphones,
      'qty': 2,
    },
  ];

  double getTotalPrice() {
    return cartItems.fold(
        0, (sum, item) => sum + item['price'] * item['qty']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.favorite_border),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return CustomContainer(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    padding: EdgeInsets.all(0),
                    child: Row(
                      children: [
                        CustomContainer(
                          backgroundColor: Colors.grey.shade300,
                          child: Icon(item['image'], size: 30),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['title'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '${item['price']} x ${item['qty']}',
                                style: TextStyle(color: Colors.grey.shade500,fontSize: 12),
                              ),
                              Row(
                                children: [
                                  Icon(Icons.currency_rupee, size: 14),
                                  Text(
                                    '${item['price'] * item['qty']}',
                                    style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
                            CustomContainer(
                              margin: EdgeInsets.all(0),
                              padding: EdgeInsets.all(0),
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        if (item['qty'] > 1) {
                                          item['qty']--;
                                        }
                                      });
                                    },
                                    icon: const Icon(Icons.remove),
                                  ),
                                  Text(
                                    '${item['qty']}',
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        item['qty']++;
                                      });
                                    },
                                    icon: const Icon(Icons.add),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            CustomContainer(
              height: 200,
              child: Column(
                children: [
                  _buildKeyValueRow('Total Items', '${cartItems.length}'),
                  _buildKeyValueRow('Discount', '₹0.00'),
                  _buildKeyValueRow('Shipping', '₹50.00'),
                  _buildKeyValueRow('Total Price', '₹${getTotalPrice().toStringAsFixed(2)}'),

                ],
              ),
            ),
            // Total & Checkout Button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Total: ₹${getTotalPrice().toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  CustomContainer(
                    backgroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    margin: EdgeInsets.all(0),
                    child: const Text(
                      'Checkout',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyValueRow(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(key, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
