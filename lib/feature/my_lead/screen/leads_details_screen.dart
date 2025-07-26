import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

import '../../../core/costants/custom_color.dart';
import '../model/lead_model.dart';
import '../model/leads_model.dart';
import '../widget/leads_details_widget.dart';
import '../widget/leads_status_widget.dart';

class LeadsDetailsScreen extends StatelessWidget {
  final String? leadName;
  final LeadsModel lead;
  const LeadsDetailsScreen({super.key, this.leadName, required this.lead});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '${leadName}', showBackButton: true,),

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
                    LeadsDetailsWidget( lead: lead,),
                    LeadsStatusWidget(checkoutId: lead.id,)
                  ],
                )),

              ],
            ),
          )),
    );
  }
}
