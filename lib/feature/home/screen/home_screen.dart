import 'package:fetchtrue/feature/home/screen/partner_review_screen.dart';
import 'package:fetchtrue/feature/home/screen/understanding_fetch_true_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/widgets/custom_highlight_service.dart';
import '../../../core/widgets/custom_search_bar.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../../provider/widget/service_provider_widget.dart';
import '../../search/screen/search_screen.dart';
import '../../banner/widget/home_banner_widget.dart';
import '../widget/all_service_widget.dart';
import '../widget/profile_card_widget.dart';
import '../widget/recommended_ervices_widget.dart';
import '../widget/refer_and_earn_widget.dart';
import '../widget/tet_widget.dart';
import '../widget/module_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key,});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
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
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchScreen())),
              ),
            ),

            /// Banner
            SliverToBoxAdapter(child: HomeBannerWidget(),),

            /// Futures
            if(userSession.userId != null)
            SliverToBoxAdapter(child: TETWidget(userId: userSession.userId,),),
            SliverToBoxAdapter(child: 15.height,),

            /// Modules
            SliverToBoxAdapter(child: ModuleWidget(dimensions: dimensions,),),
            SliverToBoxAdapter(child: 15.height,),

            /// Services for you
            SliverToBoxAdapter(child:  RecommendedServicesWidget(headline: 'Recommended Services For You',),),
            SliverToBoxAdapter(child: CustomHighlightService()),
            SliverToBoxAdapter(child: ReferAndEarnWidget()),
            SliverToBoxAdapter(child: ServiceProviderWidget(),),
            SliverToBoxAdapter(child:  AllServiceWidget(headline: 'All Services',),),
            // SliverToBoxAdapter(child: PartnerReviewVideoScreen()),
            SliverToBoxAdapter(child: 15.height,),
            SliverToBoxAdapter(child: UnderstandingFetchTrueScreen()),
            SliverToBoxAdapter(child: 15.height,),
          ],
        ),
      ),
    );
  }
}