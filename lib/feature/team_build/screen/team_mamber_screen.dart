import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_image.dart';
import '../model/my_team_model.dart';
import '../widget/team_card_widget.dart';

class TeamMemberScreen extends StatelessWidget {
  final List<TeamData> members;
  const TeamMemberScreen({super.key, required this.members});

  @override
  Widget build(BuildContext context) {

    final member = members.first.user;
    return Scaffold(
      appBar: CustomAppBar(title: 'Team Member', showBackButton: true,),

      body: DefaultTabController(
        length: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              TeamCardWidget(
                radius: 25,
                backgroundImage: AssetImage(CustomImage.nullImage),
                id: member!.id,
                memberId: member.userId,
                name: member.fullName,
                level: 'GP',
                address: 'address',
                phone: member.mobileNumber,
                earning: 'My Earning\n₹ ${members.first.totalEarningsFromShare2}',
              ),


              TabBar(
                indicatorColor: CustomColor.appColor,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                dividerColor: WidgetStateColor.transparent,
                tabs: [
                  Tab(text: 'Non GP (${0})'),
                  Tab(text: 'GP (${0})'),
                ],
              ),

              Expanded(
                child: TabBarView(
                 children: [
                   Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Icon(CupertinoIcons.person_2_fill, color: CustomColor.iconColor,size: 50,),
                       Text("No Non-GP Member"),
                     ],
                   ),
                   Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Icon(CupertinoIcons.person_2_fill, color: CustomColor.iconColor,size: 50,),
                       Text("No GP Member"),
                     ],
                   )
                 ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
