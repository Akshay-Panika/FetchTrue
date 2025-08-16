import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/feature/home/screen/understanding_fetch_true_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/widgets/custom_search_bar.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../../banner/widget/home_banner_widget.dart';
import '../../search/screen/search_service_screen.dart';
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
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0,),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [

            /// Profile App Widget
            SliverToBoxAdapter(
              child: ProfileAppWidget(),
            ),


            /// Search bar
            SliverAppBar(
              toolbarHeight: 60,
              floating: true,
              pinned: true,
              backgroundColor: CustomColor.canvasColor,
              flexibleSpace: CustomSearchBar(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  ServiceSearchScreen())),
              ),
            ),

            /// Banner
            SliverToBoxAdapter(child: HomeBannerWidget(),),

            /// Futures
            if(userSession.isLoggedIn)
            SliverToBoxAdapter(child: TETWidget(userId: userSession.userId,),),

            /// Modules
            SliverToBoxAdapter(child: ModuleWidget(),),
            SliverToBoxAdapter(child: 15.height,),
            SliverToBoxAdapter(child: ReferAndEarnWidget()),
            SliverToBoxAdapter(child: 15.height,),

            SliverToBoxAdapter(child: UnderstandingFetchTrueScreen()),



          ],
        ),
      ),
    );
  }
}