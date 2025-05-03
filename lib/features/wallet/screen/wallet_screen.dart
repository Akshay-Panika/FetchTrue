import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WalletScreen extends StatelessWidget {
  final double balance = 21948.70;

  final List<WalletTransaction> transactions = [
    WalletTransaction(id: '8137be06', leadId: '100305', amount: 119.90, dateTime: DateTime(2025, 5, 2, 18, 21)),
    WalletTransaction(id: '2d8a83dc', leadId: '100304', amount: 149.90, dateTime: DateTime(2025, 5, 2, 16, 14)),
    WalletTransaction(id: 'f1a7895c', leadId: '100303', amount: 49.90, dateTime: DateTime(2025, 5, 2, 11, 42)),
    WalletTransaction(id: '727c66b1', leadId: '100301', amount: 2499.90, dateTime: DateTime(2025, 5, 2, 10, 18)),
    WalletTransaction(id: 'e721cb95', leadId: '100300', amount: 2499.90, dateTime: DateTime(2025, 4, 30, 18, 16)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'My Wallet', showBackButton: true, showSearchIcon: true,showCartIcon: true,),
      body: Column(
        children: [
          WalletBalanceCard(balance: balance),
          Expanded(
            child: Container(
              color: Colors.grey[100],
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  return WalletTransactionTile(transaction: transactions[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WalletBalanceCard extends StatelessWidget {
  final double balance;

  const WalletBalanceCard({required this.balance});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Colors.blueAccent.withOpacity(0.3)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Your Balance", style: TextStyle(color: Colors.black, fontSize: 16)),
          const SizedBox(height: 10),
          Text(
            "₹ ${balance.toStringAsFixed(2)}",
            style: TextStyle(color: Colors.black, fontSize: 36, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildActionBtn(label: "Add", icon:Icons.add),
              const SizedBox(width: 12),
              _buildActionBtn(label: "Withdraw", icon:Icons.arrow_upward),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionBtn({String? label, IconData? icon, Color? color}) {
    return CustomContainer(
      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      child: Row(
        spacing: 5,
        children: [
           Icon(icon, size: 18),
          Text(label!, style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14)),
        ],
      ),
    );
  }
}

class WalletTransactionTile extends StatelessWidget {
  final WalletTransaction transaction;

  const WalletTransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('d MMM, y hh:mm a').format(transaction.dateTime);

    return CustomContainer(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        spacing: 5,
        children: [
          CustomContainer(
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.all(5),
            child: Icon(Icons.attach_money, color: Colors.blueAccent),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Earning from lead #${transaction.leadId}",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                Text(formattedDate, style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(),
              Text(
                "+ ₹${transaction.amount.toStringAsFixed(2)}",
                style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WalletTransaction {
  final String id;
  final String leadId;
  final double amount;
  final DateTime dateTime;

  WalletTransaction({
    required this.id,
    required this.leadId,
    required this.amount,
    required this.dateTime,
  });
}
