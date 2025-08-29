import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/feature/team_build/widget/relationship_manager_seaction_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/costants/custom_color.dart';
import 'my_gp_team_section.dart';
import 'my_non_gp_team_section.dart';


class MyTeamSectionWidget extends StatefulWidget {
  const MyTeamSectionWidget({super.key});

  @override
  State<MyTeamSectionWidget> createState() => _MyTeamSectionWidgetState();
}

class _MyTeamSectionWidgetState extends State<MyTeamSectionWidget> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverToBoxAdapter(
            child: RelationshipManagerSectionWidget(),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyHeaderDelegate(
              child: TabBar(
                indicatorColor: CustomColor.appColor,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                dividerColor: WidgetStateColor.transparent,
                tabs: const [
                  Tab(text: 'Non GP'),
                  Tab(text: 'GP'),
                ],
              ),
            ),
          ),
        ],
        body: TabBarView(
          children: [
            MyNonGpTeamSection(),
            MyGpTeamSection(),
          ],
        ),
      ),
    );
  }
}


/// _StickyHeaderDelegate
class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyHeaderDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(
      height: 50,
      child: Material( // Optional: for background color
        color: Colors.white,
        child: child,
      ),
    );
  }

  @override
  double get maxExtent => 50.0;

  @override
  double get minExtent => 50.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}