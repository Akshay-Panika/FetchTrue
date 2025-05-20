import 'package:flutter/material.dart';
import '../../../core/widgets/custom_banner.dart';
import '../../../helper/api_helper.dart';
import '../../../model/banner_model.dart';

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
          return Center(child: CircularProgressIndicator());
        }
        else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No Banner.'));
        }

        else if (snapshot.hasData || snapshot.data!.isNotEmpty) {
          final banners = snapshot.data ?? [];
          return CustomBanner(
            bannerData: banners,
            height: 180,
            onTap: (banner) => null,
            // onTap: (banner) {
            //   if(banner.selectionType == 'subcategory'){
            //     Navigator.push(context, MaterialPageRoute(builder: (context) => ModuleSubcategoryScreen(
            //       categoryId: banner.subcategory?.category ?? '',
            //     ),
            //     ));
            //   }
            //   if(banner.selectionType == 'service'){
            //     Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceDetailsScreen(image: '',),));
            //   }
            // },
          );
        }
        else{
          return Center(child: Text('No Banner.'));
        }
      },);

  }
}
