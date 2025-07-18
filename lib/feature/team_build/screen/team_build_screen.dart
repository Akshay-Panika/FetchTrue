import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../more/model/user_model.dart';
import '../../auth/repository/user_service.dart';
import '../widget/my_team_section_widget.dart';
import '../widget/invite_franchise_section_widget.dart';

class TeamLeadScreen extends StatefulWidget {
  const TeamLeadScreen({super.key});

  @override
  State<TeamLeadScreen> createState() => _TeamLeadScreenState();
}

class _TeamLeadScreenState extends State<TeamLeadScreen> {

  String? userId;
  String? token;
  UserModel? userData;

  final UserService userService = UserService();

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('userId');
    final tkn = prefs.getString('token');

    setState(() {
      userId = id;
      token = tkn;
    });

    if (id != null) {
      final user = await userService.fetchUserById(id);
      setState(() {
        userData = user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(title: 'Team Build', showBackButton: true),
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
               Expanded(
                child: TabBarView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    InviteFranchiseSectionWidget(userData: userData,),
                    MyTeamSectionWidget(userData: userData,),
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
