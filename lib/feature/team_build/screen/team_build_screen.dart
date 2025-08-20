import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:provider/provider.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/widgets/custom_appbar.dart';

import '../../../core/widgets/no_user_sign_widget.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../widget/invite_franchise_section_widget.dart';
import '../widget/my_team_section_widget.dart';

class TeamBuildScreen extends StatefulWidget {
  const TeamBuildScreen({super.key,});

  @override
  State<TeamBuildScreen> createState() => _TeamBuildScreenState();
}

class _TeamBuildScreenState extends State<TeamBuildScreen> with TickerProviderStateMixin {
  late TabController _tabController;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
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
                controller: _tabController,
                physics: const BouncingScrollPhysics(),
                children: [
                  InviteFranchiseSectionWidget(),
                  MyTeamSectionWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
