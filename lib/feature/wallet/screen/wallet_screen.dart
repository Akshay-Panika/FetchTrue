import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/formate_price.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_amount_text.dart';
import '../../../core/widgets/custom_container.dart';
import '../../package/bloc/package/package_bloc.dart';
import '../../package/bloc/package/package_state.dart';
import '../bloc/wallet_bloc.dart';
import '../bloc/wallet_state.dart';
import '../model/wallet_model.dart';

class WalletScreen extends StatefulWidget {
  final String userId;
  const WalletScreen({super.key, required this.userId});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {


  @override
  Widget build(BuildContext context) {
    print('____________${widget.userId}');
    return Scaffold(
      appBar: CustomAppBar(title: 'Wallet', showBackButton: true,),

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
                    child:TabBar(
                      isScrollable: false,
                      labelColor: CustomColor.appColor,
                      unselectedLabelColor: CustomColor.descriptionColor,
                      indicatorColor: CustomColor.appColor,
                      physics: AlwaysScrollableScrollPhysics(),
                      tabs: const [
                        Tab(text: "Self Earning"),
                        Tab(text: "Team Build"),
                        Tab(text: "Team Revenue"),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Container(
                      color: CustomColor.whiteColor,
                      child: TabBarView(
                        children: [
                          _buildSelfEarning(context),
                          _buildTeamBuildEarning(context),
                          _buildTeamRevenueEarning(context),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is WalletError) {
            print('Error: ${state.message}');
            return SizedBox.shrink();
          }
          return const SizedBox();
        },
      ),
    );
  }

}

/// wallet card
Widget _buildStatsCard(BuildContext context,WalletModel wallet ) {

  return CustomContainer(
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
                  amount: '${wallet.balance}',
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
        BlocBuilder<PackageBloc, PackageState>(
          builder: (context, state) {
            if (state is PackageLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is PackageLoaded) {
              final data = state.packages.first;
              return Column(
                children: [
                  _earningRow(context,"Franchise Deposit", "₹ ${formatPrice(data.deposit)}"),
                  _earningRow(context,"Monthly Fix Earnings", "₹ ${formatPrice(data.monthlyEarnings)}"), // Placeholder
                  _earningRow(context,"Lock In Period", "${data.lockInPeriod}, Month"),
                ],
              );
            } else if (state is PackageError) {
               print("Error: ${state.error}");
               return SizedBox.shrink();
            }
            return SizedBox.shrink();
          },
        ),

      ],
    ),
  );
}

Widget _buildSelfEarning(BuildContext context) {
  final state = context.watch<WalletBloc>().state;

  List<TransactionModel> transactions = [];
  if (state is WalletLoaded) {
    transactions = state.wallet.transactions.where((tx) {
      return tx.description.toLowerCase().contains('self earning');
    }).toList().reversed.toList();
  }

  if (transactions.isEmpty) {
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
                  formatDateTime(tx.createdAt),
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
                  Text('${tx.type}',
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

Widget _buildTeamBuildEarning(BuildContext context) {
  final state = context.watch<WalletBloc>().state;

  List<TransactionModel> transactions = [];
  if (state is WalletLoaded) {
    transactions = state.wallet.transactions.where((tx) {
      return tx.description.toLowerCase().contains('team build');
    }).toList().reversed.toList();
  }

  if (transactions.isEmpty) {
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
              backgroundColor: Colors.white,
              child: Icon(
                isCredit
                    ? CupertinoIcons.arrow_turn_left_down
                    : CupertinoIcons.arrow_turn_left_up,
                color: isCredit ? CustomColor.appColor : CustomColor.redColor,
              ),
            ),
            title: Text('Franchise Id: ${tx.commissionFrom}', style: textStyle12(context)),
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
                  formatDateTime(tx.createdAt),
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
                  Text('${tx.type}',
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

Widget _buildTeamRevenueEarning(BuildContext context) {
  final state = context.watch<WalletBloc>().state;

  List<TransactionModel> transactions = [];
  if (state is WalletLoaded) {
    transactions = state.wallet.transactions.where((tx) {
      return tx.description.toLowerCase().contains('team revenue');
    }).toList().reversed.toList();
  }

  if (transactions.isEmpty) {
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
                  formatDateTime(tx.createdAt),
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
                  Text('${tx.type}',
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