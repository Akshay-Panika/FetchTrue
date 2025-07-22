import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/no_user_sign_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_amount_text.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_container.dart';
import '../model/wallet_model.dart';
import '../repository/wallet_service.dart';

class WalletScreen extends StatefulWidget {
  final String userId;
  const WalletScreen({super.key, required this.userId});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  WalletModel? _walletData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.userId.isNotEmpty) {
      _fetchWallet();
    } else {
      isLoading = false;
    }
  }

  Future<void> _fetchWallet() async {
    try {
      final wallet = await WalletService.fetchWalletByUser(widget.userId);
      setState(() {
        _walletData = wallet;
        isLoading = false;
      });
    } catch (e) {
      print('Wallet fetch failed: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(title: 'Wallet', showBackButton: true),
      body: isLoading
          ? _buildShimmer()
          : DefaultTabController(
        length: 3,
        child: Column(
          children: [
            _buildStatsCard(context),

            Container(
              color: CustomColor.whiteColor,
              child: Row(
                children: [
                  15.width,
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TabBar(
                        isScrollable: true,
                        labelColor: CustomColor.appColor,
                        unselectedLabelColor: CustomColor.descriptionColor,
                        indicatorColor: CustomColor.appColor,
                        padding: EdgeInsets.zero,
                        tabs: const [
                          Tab(text: "Self"),
                          Tab(text: "Team Build"),
                          Tab(text: "Team Revenue"),
                        ],
                      ),
                    ),
                  ),
                  CustomContainer(
                    backgroundColor: CustomColor.whiteColor,
                    onTap: () {
                      _showFilterSheet(context);
                    },
                    child: Icon(Icons.filter_list, color: CustomColor.iconColor),
                  )

                ],
              ),
            ),

            if (widget.userId.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 150.0),
                child: NoUserSignWidget(),
              ),

            if (widget.userId.isNotEmpty)
            Expanded(
              child: Container(
                color: CustomColor.whiteColor,
                child: TabBarView(
                  children: [
                    _buildTransactionList(),
                    _noDataFound(context), // Placeholder for "Team Build"
                    _noDataFound(context), // Placeholder for "Team Revenue"
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(BuildContext context) {
    final wallet = _walletData;

    return Container(
      color: CustomColor.canvasColor,
      child: Column(
        children: [
          CustomContainer(
            border: true,
            backgroundColor: CustomColor.whiteColor,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Earnings Statistics",
                      style: textStyle16(context,
                          fontWeight: FontWeight.w400,
                          color: CustomColor.appColor),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CustomAmountText(
                          amount: wallet?.balance.toStringAsFixed(2) ?? "00",
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                        Text(
                          "Total Earnings",
                          style: textStyle12(context,
                              color: CustomColor.appColor),
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(height: 24, thickness: 0.5),
                _earningRow("Franchise Deposit", "₹ 00"),
                _earningRow("Monthly Fix Earnings", "₹ 00"), // Placeholder
                _earningRow("Lock In Period", "00, Month"),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: CustomContainer(
                  border: true,
                  backgroundColor: CustomColor.whiteColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(CupertinoIcons.arrow_turn_left_down),
                      10.width,
                      Text('Add Amount', style: textStyle14(context)),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: CustomContainer(
                  border: true,
                  backgroundColor: CustomColor.whiteColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(CupertinoIcons.arrow_turn_up_right),
                      10.width,
                      Text('Withdraw Amount', style: textStyle14(context)),
                    ],
                  ),
                  // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentScreen(),)),
                ),
              ),
            ],
          )
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
          Text(title, style: textStyle14(context, fontWeight: FontWeight.w400)),
          Text(value, style: textStyle14(context,fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }

  Widget _buildTransactionList() {

    final transactions = _walletData?.transactions;

    if (transactions == null || transactions.isEmpty) {
      return const Center(child: Text('No transactions.'));
    }

    return ListView.builder(
      itemCount: transactions.length,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemBuilder: (context, index) {
        final tx = transactions[index];
        final isCredit = tx.type == 'credit';

        return Column(
          children: [
            ListTile(
              minLeadingWidth: 0,
              contentPadding: const EdgeInsets.only(top: 10),
              leading: CircleAvatar(
                backgroundColor: CustomColor.whiteColor,
                child: Icon(
                  isCredit
                      ? CupertinoIcons.arrow_turn_left_down
                      : CupertinoIcons.arrow_turn_left_up,
                  color: isCredit ? CustomColor.appColor : CustomColor.redColor,
                ),
              ),
              title: Text('Ref #${tx.referenceId.substring(0, 6)}', style: textStyle12(context)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tx.description,
                      style: textStyle12(
                        context,
                        color: CustomColor.descriptionColor,
                        fontWeight: FontWeight.w400,
                      )),
                  Text(
                    DateFormat('dd MMM yyyy, hh:mm a').format(tx.createdAt.toLocal()),
                    style: textStyle12(
                      context,
                      color: CustomColor.descriptionColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
          trailing: Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('₹ ${tx.amount}',
                    style: textStyle12(context, fontWeight: FontWeight.w500)),
                Text('Amount',
                    style: textStyle12(context, fontWeight: FontWeight.w400)),
              ],
            ),
          )),
            const Divider(color: Colors.grey, thickness: 0.3),
          ],
        );
      },
    );
  }

}

Widget _noDataFound(BuildContext context) {
  return ListView.builder(
    itemCount: 10,
    padding: EdgeInsets.symmetric(horizontal: 10),
    itemBuilder: (context, index) {
      return Column(
        children: [
          ListTile(
            minLeadingWidth: 0,
            contentPadding: EdgeInsets.only(top: 10),
            leading: CircleAvatar(
              backgroundColor: CustomColor.whiteColor,
              child: Icon(
                index == 2 || index == 5
                    ? CupertinoIcons.arrow_turn_left_down
                    : CupertinoIcons.arrow_turn_left_up,
                color: index == 2 || index == 5 ? CustomColor.appColor : CustomColor.redColor,
              ),
            ),
            title: Text('Id #0001', style: textStyle12(context),),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name', style: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),
                Text('Other', style: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),
              ],
            ),
            trailing: Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('₹ 00.00', style: textStyle12(context, fontWeight: FontWeight.w400),),
                  Text('Amount', style: textStyle12(context, fontWeight: FontWeight.w400),),
                ],
              ),
            ),
          ),
          Divider(color: Colors.grey,thickness: 0.3,)
        ],
      );
    },);
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
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  label: 'Apply',
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

Widget _buildShimmer() {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(12),
    child: Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats Card
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          SizedBox(height: 16),

          // Buttons
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          15.height,

          CustomContainer(
            height: 40,
            margin: EdgeInsets.zero,
            backgroundColor: CustomColor.whiteColor,
          ),

          SizedBox(height: 20),

          // Transaction list shimmer
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 7,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    // Icon
                    Container(
                      width: 40,
                      height: 40,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    // Title & Subtitle
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 10,
                            width: double.infinity,
                            color: Colors.white,
                          ),
                          SizedBox(height: 6),
                          Container(
                            height: 10,
                            width: 150,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    // Amount
                    Container(
                      height: 10,
                      width: 60,
                      color: Colors.white,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    ),
  );
}