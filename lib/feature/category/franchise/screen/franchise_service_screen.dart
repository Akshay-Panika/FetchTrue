import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/costants/custom_color.dart';
import '../../../../core/costants/dimension.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../banner/bloc/banner/banner_bloc.dart';
import '../../../banner/bloc/banner/banner_event.dart';
import '../../../banner/bloc/banner/banner_state.dart';
import '../../../banner/repository/banner_repository.dart';
import '../../../highlight_serive/highlight_widget.dart';
import '../../../../core/widgets/custom_search_bar.dart';
import '../../../banner/widget/category_banner_widget.dart';
import '../../../provider/widget/service_provider_widget.dart';
import '../../../search/screen/search_screen.dart';
import '../wisget/franchise_all_service_widget.dart';
import '../wisget/franchise_category_widget.dart';
import '../wisget/franchise_recommended_service_widget.dart';


class FranchiseServiceScreen extends StatelessWidget {
  final String moduleId;
  const FranchiseServiceScreen({super.key, required this.moduleId});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    final double searchBarHeight = 30;

    return Scaffold(

      body: CustomScrollView(
        slivers: [

          SliverAppBar(
            expandedHeight: 150 + searchBarHeight,
            leading: InkWell(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.arrow_back_ios, color: CustomColor.whiteColor,)),
            title: Text('Franchise Service', style: textStyle16(context, color: CustomColor.whiteColor),),
            titleSpacing: 0,
            pinned: true,
            stretch: true,
            backgroundColor: Colors.blue.shade500,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Stack(
                fit: StackFit.expand,
                children: [
                   Padding(
                     padding: const EdgeInsets.only(left: 15.0, right: 15,top: 15),
                     child: Center(child: Text('Franchise your business and reach customers across every region.',
                     style: textStyle16(context, color: CustomColor.whiteColor),)),
                   )
                ],
              ),
            ),
            bottom: PreferredSize(
                preferredSize: Size.fromHeight(searchBarHeight),
                child: CustomSearchBar()),
          ),

          SliverToBoxAdapter(
            child: BlocProvider(
              create: (_) => BannerBloc(BannerRepository())..add(FetchBanners(page: 'category')),
              child: BlocBuilder<BannerBloc, BannerState>(
                builder: (context, state) {
                  if (state is BannerLoading) {
                    return Container(height: 180, color: Colors.grey[200],);
                  } else if (state is BannerLoaded) {
                    // final banners = state.banners;
                    final banners = state.banners
                        .where((banner) => banner.module!.id == moduleId)
                        .toList();

                    if (banners.isEmpty) return const SizedBox.shrink();

                    return SizedBox(
                      height: 180,
                      width: double.infinity,
                      child: CarouselSlider.builder(
                        itemCount: banners.length,
                        itemBuilder: (context, index, realIndex) {
                          final banner = banners[index];
                          return CachedNetworkImage(
                            imageUrl: banner.file,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            placeholder: (context, url) => Container(color: Colors.grey[200]),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          );
                        },
                        options: CarouselOptions(
                          autoPlay: true,
                          enlargeCenterPage: true,
                          viewportFraction: 1,
                          aspectRatio: 16 / 9,
                        ),
                      ),
                    );
                  } else if (state is BannerError) {
                    print('Error ${state.message}');
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),

          SliverToBoxAdapter(child: 10.height,),

          /// Category
          SliverToBoxAdapter(
            child: FranchiseCategoryWidget(moduleIndexId: moduleId),
          ),

          SliverToBoxAdapter(
            child: Column(
              children: [
                10.height,

                /// Services for you
                FranchiseRecommendedServiceWidget(headline: 'Recommended Service', moduleIndexId: moduleId,),

                /// Highlight service
                HighlightServiceWidget(),

                ///  Service Provider
                ServiceProviderWidget(),

                /// Popular Services
                Container(
                    color: CustomColor.appColor.withOpacity(0.1),
                    child: FranchiseAllServiceWidget(headline: 'All Services', moduleIndexId: moduleId,)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
