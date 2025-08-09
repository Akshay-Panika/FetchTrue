import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/formate_price.dart';
import 'package:fetchtrue/core/widgets/no_user_sign_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_amount_text.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_container.dart';
import '../bloc/wallet_bloc.dart';
import '../bloc/wallet_event.dart';
import '../bloc/wallet_state.dart';
import '../model/wallet_model.dart';
import '../repository/wallet_service.dart';
import 'add_amount.dart';

class WalletScreen extends StatefulWidget {
  final String userId;
  const WalletScreen({super.key, required this.userId});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
        create: (_) => WalletBloc()..add(FetchWallet(widget.userId)),
        child: Scaffold(
          appBar: CustomAppBar(title: 'Wallet', showBackButton: true),
          body: BlocBuilder<WalletBloc, WalletState>(
            builder: (context, state) {
              if (state is WalletLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is WalletLoaded) {
                final wallet = state.wallet;
                return DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [

                      _buildStatsCard(context, wallet),

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
                              color: CustomColor.whiteColor,
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
                                _buildSelfTransactionList(context),
                                _noDataFound(context),
                                _noDataFound(context),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              } else if (state is WalletError) {
                return Center(child: Text(state.message));
              }
              return const SizedBox();
            },
          ),
        )  );
  }

}

/// wallet card
Widget _buildStatsCard(BuildContext context,WalletModel wallet ) {

  return Container(
    color: CustomColor.canvasColor,
    child: Column(
      children: [
        CustomContainer(
          border: true,
          color: CustomColor.whiteColor,
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
                        amount: formatPrice(wallet.balance),
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
              _earningRow(context,"Franchise Deposit", "₹ 00"),
              _earningRow(context,"Monthly Fix Earnings", "₹ 00"), // Placeholder
              _earningRow(context,"Lock In Period", "00, Month"),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
              child: CustomContainer(
                border: true,
                color: CustomColor.whiteColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(CupertinoIcons.arrow_turn_left_down),
                    10.width,
                    Text('Add Amount', style: textStyle14(context)),
                  ],
                ),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AmountScreen(),)),
              ),
            ),
            Expanded(
              child: CustomContainer(
                border: true,
                color: CustomColor.whiteColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(CupertinoIcons.arrow_turn_up_right),
                    10.width,
                    Text('Withdraw Amount', style: textStyle14(context)),
                  ],
                ),
                // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddAmountScreen(),)),
              ),
            ),
          ],
        )
      ],
    ),
  );
}

Widget _buildSelfTransactionList(BuildContext context) {
  // Access current state from Bloc
  final state = context.watch<WalletBloc>().state;

  List<TransactionModel>? transactions;

  if (state is WalletLoaded) {
    // Filter transactions for "Self" tab only if needed
    // Assuming you want all transactions or filtered by description/type here
    transactions = state.wallet.transactions.where((tx) {
      // Example filter: only transactions with description containing "Self"
      return tx.description.toLowerCase().contains('self');
    }).toList();
  } else {
    transactions = [];
  }

  if (transactions.isEmpty) {
    return const Center(child: Text('No transactions.'));
  }

  return ListView.builder(
    itemCount: transactions.length,
    padding: const EdgeInsets.symmetric(horizontal: 10),
    itemBuilder: (context, index) {
      final tx = transactions![index];
      final isCredit = tx.type == 'credit';

      return Column(
        children: [
          ListTile(
            minLeadingWidth: 0,
            contentPadding: const EdgeInsets.only(top: 10),
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                isCredit
                    ? CupertinoIcons.arrow_turn_left_down
                    : CupertinoIcons.arrow_turn_left_up,
                color: isCredit ? CustomColor.appColor : CustomColor.redColor,
              ),
            ),
            title: Text('Lead Id: ${tx.leadId}', style: textStyle12(context)),
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
                  DateFormat('dd MMM yyyy, hh:mm a').format(tx.createdAt!),
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
                  Text('₹ ${tx.amount.toStringAsFixed(2)}',
                      style: textStyle12(context, fontWeight: FontWeight.w500)),
                  Text('Amount',
                      style: textStyle12(context, fontWeight: FontWeight.w400)),
                ],
              ),
            ),
          ),
          const Divider(color: Colors.grey, thickness: 0.3),
        ],
      );
    },
  );
}

Widget _earningRow(BuildContext context, String title, String value,) {
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
            color: CustomColor.whiteColor,
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