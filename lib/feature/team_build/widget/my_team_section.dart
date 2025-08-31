import 'package:fetchtrue/feature/team_build/widget/my_gp_team_section.dart';
import 'package:fetchtrue/feature/team_build/widget/my_non_gp_team_section.dart';
import 'package:fetchtrue/feature/team_build/widget/relationship_manager_card_widget.dart';
import 'package:fetchtrue/feature/team_build/widget/relationship_manager_seaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../core/costants/custom_color.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../bloc/my_team/my_team_bloc.dart';
import '../bloc/my_team/my_team_event.dart';
import '../bloc/my_team/my_team_state.dart';
import '../model/my_team_model.dart';

class MyTeamSection extends StatefulWidget {
  const MyTeamSection({super.key});

  @override
  State<MyTeamSection> createState() => _MyTeamSectionState();
}

class _MyTeamSectionState extends State<MyTeamSection> {
  bool _isLoaded = false;

   @override
  void initState() {
    super.initState();
    if (!_isLoaded) {
      final userSession = Provider.of<UserSession>(context, listen: false);
      context.read<MyTeamBloc>().add(FetchMyTeam(userSession.userId!));
      _isLoaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const RelationshipManagerSection(),
          Expanded(
            child: BlocBuilder<MyTeamBloc, MyTeamState>(
              builder: (context, state) {
                if (state is MyTeamLoading) {
                  return Align(
                      alignment: Alignment.topCenter,
                      child: LinearProgressIndicator(color: CustomColor.appColor,minHeight: 2,));
                } else if (state is MyTeamLoaded) {
                  final List<TeamData> team = state.response.team;

                  if (team.isEmpty) {
                    return const Center(child: Text("No team data found"));
                  }

                  final nonGpMembers = team.where((e) => e.user?.packageActive == false).toList();
                  final gpMembers = team.where((e) => e.user?.packageActive == true).toList();

                  return Column(
                    children: [
                      TabBar(
                        indicatorColor: CustomColor.appColor,
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.grey,
                        dividerColor: WidgetStateColor.transparent,
                        tabs: [
                          Tab(text: 'Non GP (${nonGpMembers.length})'),
                          Tab(text: 'GP (${gpMembers.length})'),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            /// Non GP Tab
                            nonGpMembers.isEmpty
                                ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(CupertinoIcons.person_2_fill, color: CustomColor.iconColor,size: 50,),
                                    Text("No Non-GP Member"),
                                  ],
                                )
                                : MyNonGpTeamSection(members: nonGpMembers),

                            /// GP Tab
                            gpMembers.isEmpty
                                ?  Column(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(CupertinoIcons.person_2_fill, color: CustomColor.iconColor,size: 50,),
                                    Text("No GP Member"),
                                  ],
                                )
                                : MyGpTeamSection(members: gpMembers),
                          ],
                        ),
                      ),

                    ],
                  );
                } else if (state is MyTeamError) {
                  return Center(child: Text("Error: ${state.message}"));
                }
                return const SizedBox();
              },
            ),
          )
        ],
      ),
    );
  }
}

