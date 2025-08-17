import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/costants/custom_color.dart';
import '../../../../core/costants/text_style.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../banner/bloc/banner/banner_bloc.dart';
import '../../../banner/bloc/banner/banner_event.dart';
import '../../../banner/bloc/banner/banner_state.dart';
import '../../../banner/repository/banner_repository.dart';
import '../../../highlight_serive/highlight_widget.dart';
import '../../../../core/widgets/custom_search_bar.dart';
import '../../../../core/widgets/custom_service_list.dart';
import '../../../banner/widget/category_banner_widget.dart';
import '../../../provider/widget/service_provider_widget.dart';
import '../../../search/screen/search_screen.dart';
import '../../franchise/wisget/franchise_category_widget.dart';
import '../wisget/marketing_all_service_widget.dart';
import '../wisget/marketing_category_widget.dart';
import '../wisget/marketing_recommended_service_widget.dart';

class MarketingServiceScreen extends StatefulWidget {
  final String moduleId;
  const MarketingServiceScreen({super.key, required this.moduleId});

  @override
  State<MarketingServiceScreen> createState() => _MarketingServiceScreenState();
}

class _MarketingServiceScreenState extends State<MarketingServiceScreen> {

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
    final double searchBarHeight = 30;

    return Scaffold(

      body: CustomScrollView(
        slivers: [

          SliverAppBar(
            expandedHeight: 220 + searchBarHeight,
            leading: InkWell(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.arrow_back_ios,)),
            title: Text('Marketing Service', style: textStyle16(context,),),
            titleSpacing: 0,
            pinned: true,
            stretch: true,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: BlocProvider(
                create: (_) => BannerBloc(BannerRepository())..add(FetchBanners(page: 'category')),
                child: BlocBuilder<BannerBloc, BannerState>(
                  builder: (context, state) {
                    if (state is BannerLoading) {
                      return Container(color: Colors.grey[200],);
                    } else if (state is BannerLoaded) {
                      // final banners = state.banners;
                      final banners = state.banners
                          .where((banner) => banner.module!.id == widget.moduleId)
                          .toList();

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
                      print('Error ${state.message}');
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
            bottom: PreferredSize(
                preferredSize: Size.fromHeight(searchBarHeight),
                child: CustomSearchBar()),
          ),


          SliverToBoxAdapter(
            child: MarketingCategoryWidget(moduleIndexId: widget.moduleId,),
          ),

          SliverToBoxAdapter(
            child: Column(
              children: [
                10.height,

                /// Services for you
                MarketingRecommendedServiceWidget(headline: 'Recommended Service', moduleIndexId: widget.moduleId,),

                /// Highlight service
                HighlightServiceWidget(),


                ///  Service Provider
                ServiceProviderWidget(),

                /// Popular Services
                Container(
                    color: CustomColor.appColor.withOpacity(0.1),
                    child: MarketingAllServiceWidget(headline: 'All Services', moduleIndexId: widget.moduleId,)),
              ],
            ),
          )

        ],
      ),
    );
  }
}
