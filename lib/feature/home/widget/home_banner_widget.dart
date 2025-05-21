import 'package:bizbooster2x/feature/module/screen/module_category_screen.dart';
import 'package:bizbooster2x/feature/service/screen/service_details_screen.dart';
import 'package:flutter/material.dart';
import '../../../core/widgets/custom_banner.dart';
import '../../../helper/api_helper.dart';
import '../model/banner_model.dart';
import '../../module/screen/module_subcategory_screen.dart';
import 'home_banner_shimmer_widget.dart';

class HomeBannerWidget extends StatefulWidget {
  const HomeBannerWidget({super.key});

  @override
  State<HomeBannerWidget> createState() => _HomeBannerWidgetState();
}

class _HomeBannerWidgetState extends State<HomeBannerWidget> {

  // Future<List<BannerModel>> _homeBanners() async {
  //   final fetched = await BannerService.fetchBanners();
  //   return fetched.where((b) => b.page == 'home').toList();
  // }
  late Future<List<BannerModel>> _futureBanners;

  @override
  void initState() {
    super.initState();
    _futureBanners = _homeBanners();
  }

  Future<List<BannerModel>> _homeBanners() async {
    final fetched = await BannerService.fetchBanners();
    return fetched.where((b) => b.page == 'home').toList();
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<List<BannerModel>>(
        future: _futureBanners,
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const HomeBannerShimmerWidget();
          }

          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const SizedBox.shrink();
          }

          else if (snapshot.hasData || snapshot.data!.isNotEmpty) {
            final banners = snapshot.data!;
            return CustomBanner(
              bannerData: banners,
              height: 180,
              onTap: (banner) {
                if(banner.selectionType == 'subcategory'){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ModuleSubcategoryScreen(
                    categoryId: banner.subcategory?.category ?? '',
                  ),
                  ));
                }
                if(banner.selectionType == 'service'){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceDetailsScreen(image: '',),));
                }
              },
            );
          }

          else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          else{
            return const Center(child: Text('No banner'));
          }

        },);

  }

}
