import 'package:fetchtrue/core/costants/custom_image.dart';
import 'package:fetchtrue/feature/team_build/model/my_team_model.dart';
import 'package:fetchtrue/feature/team_build/widget/team_card_widget.dart';
import 'package:flutter/cupertino.dart';

class MyNonGpTeamSection extends StatelessWidget {
  final List<TeamData> members;
  const MyNonGpTeamSection({super.key, required this.members});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView.builder(
        itemCount: members.length,
        padding: EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (context, index) {

          final member = members[index].user;
          final earnings = members[index].totalEarningsFromShare2;

        return TeamCardWidget(
          radius: 25,
          backgroundImage: member!.profilePhoto == null ? AssetImage(CustomImage.nullImage) :NetworkImage(member.profilePhoto!),
          id: member.id,
          memberId: member.userId,
          name: member.fullName,
          level: 'Non-GP',
          address: 'address',
          phone: member.mobileNumber,
          earning: 'Earning\n Opportunity ₹ ${earnings}',
        );
      },),
    );
  }
}
