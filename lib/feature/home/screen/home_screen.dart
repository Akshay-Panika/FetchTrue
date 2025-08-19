import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:fetchtrue/feature/home/screen/understanding_fetch_true_screen.dart';
import 'package:fetchtrue/feature/search/screen/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/widgets/custom_search_bar.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../../banner/widget/home_banner_widget.dart';
import '../../favorite/screen/favorite_screen.dart';
import '../../module/widget/module_widget.dart';
import '../widget/feature_widget.dart';
import '../widget/profile_card_widget.dart';
import '../widget/refer_and_earn_widget.dart';

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
      backgroundColor: CustomColor.whiteColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 320 + searchBarHeight,
            pinned: true,
            stretch: true,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  /// Banner
                  HomeBannerWidget(),

                  /// Overlay + Profile
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      children: [
                        50.height,
                        ProfileAppWidget(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(searchBarHeight),
              child: Row(
                children: [
                  Expanded(
                    child: CustomSearchBar(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => SearchScreen()),
                      ),
                    ),
                  ),
                  
                  CustomContainer(
                    border: true,
                    borderColor: CustomColor.appColor,
                    color: CustomColor.whiteColor,
                    padding: EdgeInsets.all(8),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FavoriteScreen(userId: userSession.userId),)),
                    child: Icon(Icons.favorite, color: Colors.red,),)
                ],
              ),
            ),
          ),

          /// Futures
          if (userSession.isLoggedIn)
          SliverToBoxAdapter(child: featureWidget(userSession.userId!)),

          /// Modules
          SliverToBoxAdapter(child: ModuleWidget()),
          SliverToBoxAdapter(child: 15.height),
          SliverToBoxAdapter(child: ReferAndEarnWidget()),
          SliverToBoxAdapter(child: 15.height),
          SliverToBoxAdapter(child: UnderstandingFetchTrueScreen()),
          SliverToBoxAdapter(child: 15.height),
        ],
      ),
    );
  }
}
