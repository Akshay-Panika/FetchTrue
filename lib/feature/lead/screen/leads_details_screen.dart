import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/costants/custom_color.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../../profile/model/user_model.dart';
import '../widget/leads_details_widget.dart';
import '../widget/leads_status_widget.dart';

class LeadsDetailsScreen extends StatelessWidget {
  final String? leadName;
  final String leadId;
  final UserModel user;
  const LeadsDetailsScreen({super.key, this.leadName, required this.leadId, required this.user});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(title: 'Details', showBackButton: true,),

      backgroundColor: CustomColor.whiteColor,
      body: SafeArea(
          child: DefaultTabController(
            length: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  color: Colors.white,
                  child: TabBar(
                    dividerColor: Colors.grey.shade300,
                    indicatorColor: CustomColor.appColor,
                    labelColor: Colors.black,
                    tabs: [
                      Tab(text: "Lead Details"),
                      Tab(text: "Status"),
                    ],
                  ),
                ),

                Expanded(child: TabBarView(
                  children: [
                    LeadsDetailsWidget(leadId: leadId, user: user,),
                    LeadsStatusWidget(checkoutId:leadId)
                  ],
                )),

              ],
            ),
          )),
    );
  }
}
