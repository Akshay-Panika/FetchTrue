import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:flutter/material.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../widget/my_team_section_widget.dart';
import '../widget/team_build_section_widget.dart';

class TeamLeadScreen extends StatelessWidget {
  const TeamLeadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(title: 'Team Lead', showBackButton: true),
        body: SafeArea(
          child: Column(
            children: [

              /// TabBar
              TabBar(
                indicatorColor: CustomColor.appColor,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                tabs: const [
                  Tab(text: 'Team Build'),
                  Tab(text: 'My Team'),
                ],
              ),

              const SizedBox(height: 8),

              /// TabBarView
              const Expanded(
                child: TabBarView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    TeamBuildSectionWidget(),
                    MyTeamSectionWidget(),
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
