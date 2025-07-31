import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fetchtrue/core/costants/custom_color.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../profile/bloc/user_bloc/user_bloc.dart';
import '../../profile/bloc/user_bloc/user_event.dart';
import '../../profile/bloc/user_bloc/user_state.dart';
import '../../profile/repository/user_service.dart';
import '../../profile/model/user_model.dart';
import '../widget/invite_franchise_section_widget.dart';
import '../widget/my_team_section_widget.dart';

class TeamBuildScreen extends StatefulWidget {
  final String userId;
  const TeamBuildScreen({super.key, required this.userId});

  @override
  State<TeamBuildScreen> createState() => _TeamBuildScreenState();
}

class _TeamBuildScreenState extends State<TeamBuildScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  UserModel? _userData;

  late UserBloc _userBloc;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _userBloc = UserBloc(UserService());
    _userBloc.add(FetchUserById(widget.userId));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _userBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Team Build', showBackButton: true),
      body: SafeArea(
        child: BlocProvider(
          create: (_) => _userBloc,
          child: BlocListener<UserBloc, UserState>(
            listener: (context, state) {
              if (state is UserLoaded && mounted) {
                setState(() {
                  _userData = state.user;
                });
              }
            },
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
                      InviteFranchiseSectionWidget(userData: _userData),
                      MyTeamSectionWidget(userData: _userData),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
