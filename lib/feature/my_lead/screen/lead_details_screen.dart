import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_toggle_taps.dart';
import '../model/lead_model.dart';
import '../widget/lead_details_widget.dart';
import '../widget/lead_status_widget.dart';

class LeadDetailsScreen extends StatefulWidget {
  final LeadModel lead;
  const LeadDetailsScreen({super.key, required this.lead});

  @override
  State<LeadDetailsScreen> createState() => _LeadDetailsScreenState();
}

class _LeadDetailsScreenState extends State<LeadDetailsScreen> {

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Lead Details',
        showBackButton: true,
      ),
      body: SafeArea(
          child: DefaultTabController(
        length: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              color: Colors.white,
              child: TabBar(
                dividerColor: Colors.transparent,
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
                LeadDetailsWidget(
                  dimensions: dimensions,
                  lead: widget.lead,
                ),
                LeadStatusWidget(bookingId: widget.lead.id)
              ],
            )),

          ],
        ),
      )),
    );
  }
}
