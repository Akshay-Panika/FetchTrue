import 'package:fetchtrue/feature/team_build/screen/team_mamber_screen.dart';
import 'package:fetchtrue/feature/team_build/widget/team_card_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/costants/custom_image.dart';
import '../../lead/bloc/lead/lead_bloc.dart';
import '../../lead/bloc/lead/lead_event.dart';
import '../../lead/repository/lead_repository.dart';
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

          return BlocProvider(
            create: (context) => LeadBloc(LeadRepository())..add(FetchLeadsByUser(member.id)),
            child: TeamCardWidget(
              radius: 25,
              backgroundImage: member!.profilePhoto != null && member.profilePhoto!.isNotEmpty
                  ? NetworkImage(member.profilePhoto!)
                  :  AssetImage(CustomImage.nullImage) as ImageProvider,
              id: member!.id,
              memberId: member.userId,
              name: member.fullName,
              level: member.packageStatus,
              address: '_______',
              phone: member.mobileNumber,
              earning: 'My Earning\n₹ ${earning?.toStringAsFixed(2)}',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TeamMemberScreen(members: members[index],),
                  ),
                );
              },
            ),
          );
        },),
    );
  }
}
