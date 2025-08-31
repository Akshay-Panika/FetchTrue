import 'package:fetchtrue/feature/team_build/screen/team_mamber_screen.dart';
import 'package:fetchtrue/feature/team_build/widget/team_card_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/costants/custom_image.dart';
import '../model/my_team_model.dart';

class MyGpTeamSection extends StatelessWidget {
  final List<TeamData> members;
  const MyGpTeamSection({super.key, required this.members});

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: ListView.builder(
        itemCount: members.length,
        padding: EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (context, index) {

          final member = members[index].user;
          final earning = members[index].totalEarningsFromShare2;

          return TeamCardWidget(
            radius: 25,
            backgroundImage: AssetImage(CustomImage.nullImage),
            id: member!.id,
            memberId: member.userId,
            name: member.fullName,
            level: 'GP',
            address: 'address',
            phone: member.mobileNumber,
            earning: 'My Earning\n₹ ${earning}',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TeamMemberScreen(members: members,),
                ),
              );
            },
          );
        },),
    );
  }
}
