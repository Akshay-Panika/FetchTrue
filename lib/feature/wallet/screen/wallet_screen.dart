import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:bizbooster2x/core/costants/text_style.dart';
import 'package:bizbooster2x/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';

class WalletScreen extends StatelessWidget {
  final String? isBack;
  WalletScreen({this.isBack});

  final double balance = 21948.70;
  final double totalEarning = 42150.00;

  final List<WalletTransaction> transactions = [
    WalletTransaction(
      id: 'b96573e2',
      leadId: '100305',
      amount: 119.90,
      isCredit: true,
      dateTime: DateTime(2025, 5, 2, 18, 21),
    ),
    WalletTransaction(
      id: 'c713421f',
      leadId: '100449',
      amount: 219.50,
      isCredit: true,
      dateTime: DateTime(2025, 5, 3, 11, 04),
    ),
    WalletTransaction(
      id: '2f74e6ac',
      leadId: '100305',
      amount: 119.90,
      isCredit: false,
      dateTime: DateTime(2025, 5, 4, 16, 38),
    ),
    WalletTransaction(
      id: 'b96573e2',
      leadId: '100305',
      amount: 119.90,
      isCredit: true,
      dateTime: DateTime(2025, 5, 2, 18, 21),
    ),
    WalletTransaction(
      id: 'c713421f',
      leadId: '100449',
      amount: 219.50,
      isCredit: true,
      dateTime: DateTime(2025, 5, 3, 11, 04),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'My Wallet',
        showBackButton: true,
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              toolbarHeight: 200,
              pinned: false,
              floating: true,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                background: WalletBalanceCard(
                  balance: balance,
                  totalEarning: totalEarning,
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    20.height,
                    /// Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Wallet History',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),

                        IconButton(
                          icon: Icon(Icons.filter_list),
                         onPressed: () {
                           _showFilterSheet(context);
                         },
                        ),

                      ],
                    ),
                    const SizedBox(height: 10),
                    /// Transactions List
                    ListView.builder(
                      itemCount: transactions.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return WalletTransactionTile(transaction: transactions[index]);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WalletBalanceCard extends StatelessWidget {
  final double balance;
  final double totalEarning;

  const WalletBalanceCard({
    required this.balance,
    required this.totalEarning,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.blue.shade100],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      padding: EdgeInsets.all(20),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Your Balance", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text(
                "₹ ${balance.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green[700]),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  _buildActionBtn(label: "Add", icon: Icons.add, color: Colors.green),
                  const SizedBox(width: 12),
                  _buildActionBtn(label: "Withdraw", icon: Icons.arrow_upward, color: Colors.red),
                ],
              ),
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: Text(
              'Total Earning ₹ ${totalEarning.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.blueAccent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBtn({required String label, required IconData icon, required Color color}) {
    return CustomContainer(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      backgroundColor: color,
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.white),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
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
      backgroundColor: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 6),
      padding: EdgeInsets.all(12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: transaction.isCredit ? Colors.green[100] : Colors.red[100],
            child: Icon(
              transaction.isCredit ? Icons.call_received : Icons.call_made,
              color: transaction.isCredit ? Colors.green : Colors.red,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.isCredit
                      ? "Credited from lead #${transaction.leadId}"
                      : "Debited for lead #${transaction.leadId}",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  formattedDate,
                  style: TextStyle(color: Colors.grey[700], fontSize: 13),
                ),
              ],
            ),
          ),
          Text(
            "${transaction.isCredit ? "+" : "-"} ₹ ${transaction.amount.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: transaction.isCredit ? Colors.green : Colors.red,
            ),
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
  final bool isCredit;
  final DateTime dateTime;

  const WalletTransaction({
    required this.id,
    required this.leadId,
    required this.amount,
    required this.isCredit,
    required this.dateTime,
  });
}



void _showFilterSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      final List<String> filterTabs = [
        'Months',
        'Categories',
        'Instruments',
        'Payment status',
        'Payment types',
      ];

      final List<String> months = [
        'May 2025',
        'Apr 2025',
        'Mar 2025',
        'Feb 2025',
        'Jan 2025',
        'Dec 2024',
        'Nov 2024',
        'Oct 2024',
        'Sept 2024',
        'Aug 2024',
        'Jul 2024',
        'Jun 2024',
        'May 2024',
      ];

      return StatefulBuilder(builder: (context, setState) {
        int selectedTabIndex = 0;
        Set<String> selectedMonths = {};

        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.85,
          child: Column(
            children: [
              // Header with "Filters" and "Clear All"
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Filters', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    TextButton(
                      onPressed: () {
                        setState(() => selectedMonths.clear());
                      },
                      child: Text('Clear All'),
                    ),
                  ],
                ),
              ),

              Divider(height: 1),

              Expanded(
                child: Row(
                  children: [
                    // Left Tab Menu
                    Container(
                      width: 150,
                      child: ListView.builder(
                        itemCount: filterTabs.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              filterTabs[index],
                              style: textStyle12(context,
                                fontWeight: selectedTabIndex == index
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            selected: selectedTabIndex == index,
                            onTap: () => setState(() => selectedTabIndex = index),
                          );
                        },
                      ),
                    ),

                    VerticalDivider(width: 1),

                    // Right Filter Content
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ListView.builder(
                          itemCount: months.length,
                          itemBuilder: (context, index) {
                            String month = months[index];
                            bool isSelected = selectedMonths.contains(month);

                            return CheckboxListTile(
                              value: isSelected,
                              onChanged: (val) {
                                setState(() {
                                  if (val == true) {
                                    selectedMonths.add(month);
                                  } else {
                                    selectedMonths.remove(month);
                                  }
                                });
                              },
                              title: Text(month, style: textStyle12(context),),
                              controlAffinity: ListTileControlAffinity.trailing,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Apply Button
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomButton(
                  onTap: () {
                    Navigator.pop(context);
                  },
                 text: 'Apply',
                ),
              ),
              20.height
            ],
          ),
        );
      });
    },
  );
}
