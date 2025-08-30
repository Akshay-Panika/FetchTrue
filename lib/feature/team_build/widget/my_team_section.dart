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
              Tab(text: 'Non GP'),
              Tab(text: 'GP'),
            ],
          ),

          /// TabBarView with content
          Expanded(
            child: TabBarView(
              children: [
                /// Non GP List
                ListView.builder(
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 60,
                      color: index.isEven ? Colors.red[200] : Colors.red[400],
                      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      child: Center(child: Text("Non GP Member $index")),
                    );
                  },
                ),

                /// GP List
                ListView.builder(
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 60,
                      color: index.isEven ? Colors.blue[200] : Colors.blue[400],
                      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      child: Center(child: Text("GP Member $index")),
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

