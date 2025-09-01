import 'package:fetchtrue/core/costants/custom_image.dart';
import 'package:fetchtrue/feature/team_build/model/my_team_model.dart';
import 'package:fetchtrue/feature/team_build/widget/team_card_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../lead/bloc/lead/lead_bloc.dart';
import '../../lead/bloc/lead/lead_event.dart';
import '../../lead/repository/lead_repository.dart';

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


          // final address = [
          //   if (referralUser.homeAddress?.city?.isNotEmpty == true) referralUser.homeAddress!.city,
          //   if (referralUser.homeAddress?.state?.isNotEmpty == true) referralUser.homeAddress!.state,
          // ].join(", ");

        return BlocProvider(
          create: (context) => LeadBloc(LeadRepository())..add(FetchLeadsByUser(member.id)),
          child: TeamCardWidget(
            radius: 25,
            backgroundImage: member!.profilePhoto == null ? AssetImage(CustomImage.nullImage) :NetworkImage(member.profilePhoto!),
            id: member.id,
            memberId: member.userId,
            name: member.fullName,
            level: 'Non-GP',
            address: '_______',
            phone: member.mobileNumber,
            earning: 'Earning\n Opportunity ₹ ${earnings}',
          ),
        );
      },),
    );
  }
}
