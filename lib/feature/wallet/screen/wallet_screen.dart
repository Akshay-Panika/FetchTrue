import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:bizbooster2x/core/costants/text_style.dart';
import 'package:bizbooster2x/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';

import 'package:flutter/material.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: CustomAppBar(title: 'Wallet', showBackButton: true,),
      body:  SafeArea(
        child: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              20.height,
              _buildStatsCard(),
              20.height,
              TabBar(
                labelColor: CustomColor.appColor,
                unselectedLabelColor: CustomColor.descriptionColor,
                tabs: const [
                  Tab(text: "Self"),
                  Tab(text: "Referral"),
                  Tab(text: "Reward"),
                ],
              ),

              Expanded(
                child: TabBarView(
                  children: [
                    _noDataFound(),
                    _noDataFound(),
                    _noDataFound(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildStatsCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 6)],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Earnings Statistics", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          const Text("Total Earnings", style: TextStyle(color: Colors.grey)),
          const Text("₹0.00", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          const Divider(height: 24, thickness: 1.2),
          _earningRow("Self Earnings", "₹0.00"),
          _earningRow("Referral Earnings", "₹0.00"),
          _earningRow("Reward Earnings", "₹0.00"),
        ],
      ),
    );
  }

  Widget _earningRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _noDataFound() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
         Icon(Icons.folder_off, size: 64, color: CustomColor.appColor),
        const SizedBox(height: 8),
        Text("No data found", style: TextStyle(color: Colors.grey.shade600)),
      ],
    );
  }
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
