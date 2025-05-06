import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:bizbooster2x/core/widgets/custom_toggle_taps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LeadDetailsScreen extends StatefulWidget {
  const LeadDetailsScreen({super.key});

  @override
  State<LeadDetailsScreen> createState() => _LeadDetailsScreenState();
}

class _LeadDetailsScreenState extends State<LeadDetailsScreen> {

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Lead Details', showBackButton: true,),

      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
           CustomToggleTabs(
               labels: ['Details', 'Status'],
               selectedIndex: _selectedIndex,
               onTap: (index) {
                 setState(() {
                   _selectedIndex = index;
                 });
               },)
          ],
        ),
      )),
    );
  }
}
