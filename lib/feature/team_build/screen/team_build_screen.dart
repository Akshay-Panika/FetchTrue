import 'package:flutter/material.dart';
import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/no_user_sign_widget.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../widget/invite_franchise_section.dart';
import '../widget/my_team_section.dart';

class TeamBuildScreen extends StatefulWidget {
  const TeamBuildScreen({super.key,});

  @override
  State<TeamBuildScreen> createState() => _TeamBuildScreenState();
}

class _TeamBuildScreenState extends State<TeamBuildScreen> {


  @override
  Widget build(BuildContext context) {
    final userSession = Provider.of<UserSession>(context);

    if (!userSession.isLoggedIn) {
      return Scaffold(
        appBar: CustomAppBar(
          title: 'Team Build',
          showBackButton: true,
        ),
        body: const Center(child: NoUserSignWidget()),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Team Build', showBackButton: true),
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
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
              Expanded(
                child: TabBarView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    InviteFranchiseSection(),
                    MyTeamSection(),
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
