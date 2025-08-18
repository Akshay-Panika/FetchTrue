
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fetchtrue/feature/service/screen/service_details_screen.dart';
import 'package:fetchtrue/feature/subcategory/screen/subcategory_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_url_launch.dart';
import '../bloc/banner/banner_bloc.dart';
import '../bloc/banner/banner_event.dart';
import '../bloc/banner/banner_state.dart';
import '../repository/banner_repository.dart';

class HomeBannerWidget extends StatefulWidget {
  const HomeBannerWidget({super.key});

  @override
  State<HomeBannerWidget> createState() => _HomeBannerWidgetState();
}

class _HomeBannerWidgetState extends State<HomeBannerWidget> {

  int currentIndex = 0;
  Timer? timer;

  void startAutoSlide(List banners) {
    if (timer != null && timer!.isActive) return;
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
    return  Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: BlocProvider(
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
                final banner = banners[currentIndex];
              return AnimatedSwitcher(
                duration: const Duration(seconds: 5),
                switchInCurve: Curves.easeInCubic,
                switchOutCurve: Curves.easeOutCubic,
                child: InkWell(
                  child: CachedNetworkImage(
                    key: ValueKey(banner.id),
                    imageUrl: banner.file,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    placeholder: (context, url) => CustomContainer(margin: EdgeInsets.zero,),
                    errorWidget: (context, url, error) => const Icon(Icons.error),),
                    onTap: () {
                      if (banner.selectionType == 'referralUrl') {
                        CustomUrlLaunch(banner.referralUrl!);
                      } else if (banner.selectionType == 'subcategory') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SubcategoryScreen(
                              categoryId: banner.subcategory!.category,
                              categoryName: banner.subcategory!.name,
                            ),
                          ),
                        );
                      } else if (banner.selectionType == 'service') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ServiceDetailsScreen(serviceId: banner.service!),
                          ),
                        );
                      }
                    }
                ),
              );
            } else if (state is BannerError) {
              print("Error: ${state.message}");
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
