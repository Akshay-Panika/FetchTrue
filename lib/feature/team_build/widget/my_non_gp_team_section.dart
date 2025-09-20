import 'package:fetchtrue/core/costants/custom_image.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/feature/team_build/model/my_team_model.dart';
import 'package:fetchtrue/feature/team_build/widget/team_card_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../lead/bloc/team_lead/team_lead_bloc.dart';
import '../../lead/bloc/team_lead/team_lead_event.dart';
import '../../lead/repository/lead_repository.dart';

class MyNonGpTeamSection extends StatelessWidget {
  final List<MyTeamModel> members;
  const MyNonGpTeamSection({super.key, required this.members});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return SafeArea(
      child: ListView.builder(
        itemCount: members.length,
        padding: EdgeInsets.symmetric(horizontal: dimensions.screenHeight*0.01),
        itemBuilder: (context, index) {

          final member = members[index].user;
          final earnings = members[index].totalEarningsFromShare2;

        return TeamCardWidget(
          radius: 25,
          backgroundImage: member!.profilePhoto != null && member.profilePhoto!.isNotEmpty
              ? NetworkImage(member.profilePhoto!)
              :  AssetImage(CustomImage.nullImage) as ImageProvider,
          id: member.id,
          memberId: member.userId,
          name: member.fullName,
          level: member.packageStatus== 'nonGP'?'Non-GP':member.packageStatus,
          address: '_______',
          phone: member.mobileNumber,
          earning: earnings.toString(),
          status: member.isDeleted,
        );
      },),
    );
  }
}
