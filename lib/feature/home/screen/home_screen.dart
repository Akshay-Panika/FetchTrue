import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/feature/home/screen/understanding_fetch_true_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/widgets/custom_search_bar.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../widget/module_widget.dart';
import '../widget/profile_card_widget.dart';
import '../widget/refer_and_earn_widget.dart';
import '../widget/tet_widget.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key,});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {

  @override
  Widget build(BuildContext context) {
    final userSession = Provider.of<UserSession>(context);
    final double searchBarHeight = 10;
    return Scaffold(
      body: CustomScrollView(
        slivers: [

          SliverAppBar(
            expandedHeight: 300 + searchBarHeight,
            pinned: true,
            floating: false,
            stretch: true,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Image.asset(
                  //   CustomImage.thumbnailImage,
                  //   fit: BoxFit.cover,
                  // ),
                  Container(
                    // color: CustomColor.whiteColor,
                    // color: CustomColor.appColor.withOpacity(0.1),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                        CustomColor.appColor.withOpacity(0.2),
                        CustomColor.whiteColor.withOpacity(01),
                      ])
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        children: [
                          50.height,
                          ProfileAppWidget(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(searchBarHeight),
              child: CustomSearchBar(),
            ),
          ),

          /// Futures
          if(userSession.isLoggedIn)
          SliverToBoxAdapter(child: TETWidget(userId: userSession.userId,),),

          /// Modules
          SliverToBoxAdapter(child: ModuleWidget(),),
          SliverToBoxAdapter(child: 15.height,),
          SliverToBoxAdapter(child: ReferAndEarnWidget()),
          SliverToBoxAdapter(child: 15.height,),
          SliverToBoxAdapter(child: UnderstandingFetchTrueScreen()),
          SliverToBoxAdapter(child: 15.height,),

        ],
      ),
    );
  }
}