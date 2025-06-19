import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/costants/custom_icon.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_toggle_taps.dart';
import '../../../helper/Contact_helper.dart';
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

  int _tapIndex = 0;

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return Scaffold(
      appBar: CustomAppBar(title: 'Lead Details', showBackButton: true,),

      body: SafeArea(child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          15.height,

          /// Tabs
          Padding(
            padding: EdgeInsets.symmetric(horizontal:dimensions.screenHeight*0.02),
            child: CustomToggleTabs(
              labels: ['Lead Details', 'Status'],
              selectedIndex: _tapIndex,
              onTap: (index) {
                setState(() {
                  _tapIndex = index;
                });
              },
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding:  EdgeInsets.all(15.0),
              child:
              _tapIndex ==0 ?
            LeadDetailsWidget(dimensions: dimensions, lead: widget.lead,):
              LeadStatusWidget(),
            ),
          ),
        ],
      )),
    );
  }
}



