import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/custom_toggle_taps.dart';

class TeamLeadScreen extends StatefulWidget {
  const TeamLeadScreen({super.key});

  @override
  State<TeamLeadScreen> createState() => _TeamLeadScreenState();
}

class _TeamLeadScreenState extends State<TeamLeadScreen> {

  int _tapIndex = 0;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: CustomAppBar(title: 'Team Lead',showBackButton: true,),

      body: SafeArea(child: Column(
        children: [

          /// tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: CustomToggleTabs(labels: ['Team Build', 'My Team'], selectedIndex: _tapIndex,onTap: (index) {
              setState(() {
                _tapIndex = index;
              });
            },),
          ),

          _tapIndex ==0?
          _buildReferCard() :SizedBox()

        ],
      )),
    );
  }
}


Widget _buildReferCard(){
  return Column(
    children: [
      CustomContainer(
        height: 500,width: double.infinity,
      ),
      
      Text('Invite Friends And Businesses', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
      Text('Copy your code, share it with your friends', style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),

      SizedBox(height: 50,),
      CustomContainer(
        height: 50,
        width: 200,
        backgroundColor: Colors.blueAccent.shade200,
        child: Center(child: Text('Upgrade Naw', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14, color: Colors.white),)),
      ),
    ],
  );
}