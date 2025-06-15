import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:bizbooster2x/core/costants/text_style.dart';
import 'package:bizbooster2x/core/widgets/custom_amount_text.dart';
import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:bizbooster2x/core/widgets/custom_button.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';
import 'package:bizbooster2x/core/widgets/custom_toggle_taps.dart';
import 'package:bizbooster2x/feature/my_lead/widget/lead_details_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/costants/custom_icon.dart';
import '../../../helper/Contact_helper.dart';
import '../widget/lead_status_widget.dart';

class LeadDetailsScreen extends StatefulWidget {
  const LeadDetailsScreen({super.key});

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
            LeadDetailsWidget(dimensions: dimensions,):
              LeadStatusWidget(),
            ),
          ),
        ],
      )),
    );
  }
}



