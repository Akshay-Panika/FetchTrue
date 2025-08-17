import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/feature/home/screen/understanding_fetch_true_screen.dart';
import 'package:fetchtrue/feature/search/screen/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/widgets/custom_search_bar.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../../banner/bloc/banner/banner_bloc.dart';
import '../../banner/bloc/banner/banner_event.dart';
import '../../banner/bloc/banner/banner_state.dart';
import '../../banner/repository/banner_repository.dart';
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
  int currentIndex = 0;
  Timer? timer;

  void startAutoSlide(List banners) {
    if (timer != null && timer!.isActive) return; // prevent multiple timers
    timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted) return;
      setState(() {
        currentIndex = (currentIndex + 1) % banners.length;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userSession = Provider.of<UserSession>(context);
    final double searchBarHeight = 10;

    return Scaffold(
      backgroundColor: CustomColor.whiteColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300 + searchBarHeight,
            pinned: true,
            stretch: true,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  /// Banner with Bloc
                  BlocProvider(
                    create: (_) =>
                    BannerBloc(BannerRepository())..add(FetchBanners(page: 'home')),
                    child: BlocBuilder<BannerBloc, BannerState>(
                      builder: (context, state) {
                        if (state is BannerLoading) {
                          return Container(color: Colors.grey[100]);
                        } else if (state is BannerLoaded) {
                          final banners = state.banners;
                          if (banners.isEmpty) return const SizedBox.shrink();

                          // start auto-slide timer only once
                          startAutoSlide(banners);

                          return AnimatedSwitcher(
                            duration: const Duration(seconds: 1),
                            switchInCurve: Curves.easeIn,
                            switchOutCurve: Curves.easeOut,
                            child: CachedNetworkImage(
                              key: ValueKey(banners[currentIndex].id),
                              imageUrl: banners[currentIndex].file,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              placeholder: (context, url) => Container(color: Colors.grey[100]),
                              errorWidget: (context, url, error) => const Icon(Icons.error),),
                          );
                        } else if (state is BannerError) {
                         print("Error: ${state.message}");
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),

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
              child: CustomSearchBar(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SearchScreen()),
                ),
              ),
            ),
          ),

          /// Futures
          if (userSession.isLoggedIn)
            SliverToBoxAdapter(child: TETWidget(userId: userSession.userId)),

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
