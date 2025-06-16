import 'package:bizbooster2x/feature/team_lead/widget/my_leader_card_widget.dart';
import 'package:bizbooster2x/feature/team_lead/widget/team_gp_widget.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_icon.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_toggle_taps.dart';
import '../screen/team_lead_details_screen.dart';
import 'non_gp_widget.dart';

class MyTeamSectionWidget extends StatefulWidget {
  const MyTeamSectionWidget({super.key});

  @override
  State<MyTeamSectionWidget> createState() => _MyTeamSectionWidgetState();
}

class _MyTeamSectionWidgetState extends State<MyTeamSectionWidget>  with TickerProviderStateMixin {

  bool _isUpade = false;
  bool _confirm = false;
  int _tapIndex = 0;

  late TabController _tabController;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging == false) {
        setState(() {
          _tapIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Dimensions dimensions = Dimensions(context);

    return  CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child:SizedBox(height: dimensions.screenHeight*0.02,)),

        /// Dotted boarder filed
        SliverToBoxAdapter(
            child: !_confirm? DottedBorder(
              color: Colors.grey,
              dashPattern: [10, 5], // 6px line, 3px gap
              borderType: BorderType.RRect,
              radius: Radius.circular(8),
              borderPadding: EdgeInsets.all(10),
              child: Row(
                children: [
                  SizedBox(width: 25,),
                  Expanded(flex: 2,
                    child: TextField(
                      style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),

                      decoration: const InputDecoration(
                        hintText: 'Referral Code...',
                        hintStyle: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),
                        border: InputBorder.none, // removes all borders
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                  Expanded(
                    child: CustomContainer(
                      backgroundColor: CustomColor.appColor.withOpacity(0.8),
                      onTap: () {
                        setState(() {
                          _isUpade = true;
                        });
                      },
                      child: Center(child: const Text('Update', style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500, color: Colors.white),)),
                    ),
                  ),
                ],
              ),
            ):SizedBox.shrink()),
        SliverToBoxAdapter(child:SizedBox(height: dimensions.screenHeight*0.015,)),

        /// Profile card
        SliverToBoxAdapter(child:_isUpade? Column(
          children: [
            MyLeaderCardWidget(),
            if(!_confirm)
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: dimensions.screenWidth*0.02),
                child: Row(
                  children: [
                    Expanded(child: CustomContainer(
                      border: true,
                      backgroundColor: CustomColor.whiteColor,
                      onTap: () {
                        setState(() {
                          _confirm = true;
                        });
                      },
                      child: Center(child: Text('Cancel', style: textStyle16(context, color: CustomColor.redColor),)),)),
                    20.width,
                    Expanded(child: CustomContainer(
                      border: true,
                      backgroundColor: CustomColor.whiteColor,
                      onTap: () {
                        setState(() {
                          _confirm = true;
                        });
                      },
                      child: Center(child: Text('Confirm', style: textStyle16(context, color: CustomColor.appColor),)),)),
                  ],
                ),
              ),
          ],
        ):null),
        SliverToBoxAdapter(child:SizedBox(height: dimensions.screenHeight*0.015,)),


        /// Tabs
        SliverPersistentHeader(
          pinned: true,
          delegate: _StickyHeaderDelegate(
            child: TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: 'Non-GP'),
                Tab(text: 'Team-GP'),
              ],
              dividerColor: Colors.transparent,
              indicatorColor: CustomColor.appColor,
              labelColor: CustomColor.appColor,
              unselectedLabelColor: CustomColor.descriptionColor,
            ),
          ),
        ),




        /// Non- gp, Team gp
        SliverList(
            delegate: _tapIndex ==0 ?
            SliverChildBuilderDelegate(
              childCount: 6,
                  (context, index) {
               return NonGpWidget();
              },
            ):

            SliverChildBuilderDelegate(
              childCount: 5,
                  (context, index) {
                return TeamGpWidget();
              },
            )),
        SliverToBoxAdapter(child:SizedBox(height: dimensions.screenHeight*0.02,)),


      ],
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

