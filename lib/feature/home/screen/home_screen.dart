import 'package:fetchtrue/core/costants/custom_image.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/feature/home/screen/understanding_fetch_true_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../../banner/widget/home_banner_widget.dart';
import '../../internet/network_wrapper_screen.dart';
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

  final ScrollController _scrollController = ScrollController();
  bool _isCollapsed = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    final isCollapsed = _scrollController.offset > 150;
    if (isCollapsed != _isCollapsed) {
      setState(() => _isCollapsed = isCollapsed);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userSession = Provider.of<UserSession>(context);
    final double searchBarHeight = 50;

    return NetworkWrapper(
      child: Scaffold(
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            CustomHomeSliverAppbarWidget(
              isCollapsed: _isCollapsed,
              searchBarHeight: searchBarHeight,
              background: HomeBannerWidget()
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
      ),
    );
  }
}