import 'package:fetchtrue/feature/team_build/widget/my_gp_team_section.dart';
import 'package:fetchtrue/feature/team_build/widget/my_non_gp_team_section.dart';
import 'package:fetchtrue/feature/team_build/widget/relationship_manager_seaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/costants/custom_color.dart';

class MyTeamSection extends StatefulWidget {
  const MyTeamSection({super.key});

  @override
  State<MyTeamSection> createState() => _MyTeamSectionState();
}

class _MyTeamSectionState extends State<MyTeamSection> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          /// Relationship Manager Section
          const RelationshipManagerSection(),

          /// Sticky TabBar
          TabBar(
            indicatorColor: CustomColor.appColor,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            dividerColor: WidgetStateColor.transparent,
            tabs: const [
              Tab(text: 'Non GP (0)'),
              Tab(text: 'GP (0)'),
            ],
          ),

          /// TabBarView with content
          Expanded(
            child: TabBarView(
              children: [
                MyNonGpTeamSection(),
                MyGpTeamSection()
              ],
            ),
          )
        ],
      ),
    );
  }
}

