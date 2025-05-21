import 'package:flutter/material.dart';
import '../../../core/widgets/custom_banner.dart';
import '../../../helper/api_helper.dart';
import '../../home/model/banner_model.dart';
import '../../home/widget/home_banner_shimmer_widget.dart';

class CategoryBannerWidget extends StatefulWidget {
  const CategoryBannerWidget({super.key});

  @override
  State<CategoryBannerWidget> createState() => _CategoryBannerWidgetState();
}

class _CategoryBannerWidgetState extends State<CategoryBannerWidget> {
  Future<List<BannerModel>> _homeBanners() async {
    final fetched = await BannerService.fetchBanners();
    return fetched.where((b) => b.page == 'category').toList();
  }


  @override
  Widget build(BuildContext context) {

    return FutureBuilder<List<BannerModel>>(
      future: _homeBanners(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return HomeBannerShimmerWidget();
        }

        else if (!snapshot.hasData && snapshot.data!.isEmpty){
          return Center(child: Text('No Banner.'));
        }
        else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final banners = snapshot.data!;
        return CustomBanner(
          bannerData: banners,
          height: 180,
         onTap: (banner) {

         },
        );


      },);

  }
}
