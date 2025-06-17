import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_toggle_taps.dart';
import '../widget/my_team_section_widget.dart';
import '../widget/team_build_section_widget.dart';


class TeamLeadScreen extends StatefulWidget {
  const TeamLeadScreen({super.key});

  @override
  State<TeamLeadScreen> createState() => _TeamLeadScreenState();
}

class _TeamLeadScreenState extends State<TeamLeadScreen> {
  int _tapIndex = 0;

  @override
  Widget build(BuildContext context) {

    Dimensions dimensions = Dimensions(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Team Lead', showBackButton: true),
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              /// Tabs
              Padding(
                padding: EdgeInsets.symmetric(horizontal:dimensions.screenHeight*0.02),
                child: CustomToggleTabs(
                  labels: ['Team Build', 'My Team'],
                  selectedIndex: _tapIndex,
                  onTap: (index) {
                    setState(() {
                      _tapIndex = index;
                    });
                  },
                ),
              ),
              // 10.height,

              /// Tab Content
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _tapIndex == 0
                      ? const TeamBuildSectionWidget()
                      : const MyTeamSectionWidget(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



