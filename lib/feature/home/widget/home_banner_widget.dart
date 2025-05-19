import 'package:bizbooster2x/feature/module/screen/module_category_screen.dart';
import 'package:bizbooster2x/feature/service/screen/service_details_screen.dart';
import 'package:flutter/material.dart';
import '../../../core/widgets/custom_banner.dart';
import '../../../helper/api_helper.dart';
import '../../../model/banner_model.dart';
import '../../module/screen/module_subcategory_screen.dart';

class HomeBannerWidget extends StatefulWidget {
  const HomeBannerWidget({super.key});

  @override
  State<HomeBannerWidget> createState() => _HomeBannerWidgetState();
}

class _HomeBannerWidgetState extends State<HomeBannerWidget> {
  List<BannerModel> banners = [];
  bool isLoading = true;


  @override
  void initState() {
    super.initState();
    loadBanners();
  }

  Future<void> loadBanners() async {
    try {
      final fetched = await BannerService.fetchBanners();
      setState(() {
        banners = fetched.where((b) => b.page == 'home').toList(); // filter by 'home' page
      });
    } catch (e) {
      debugPrint('Error loading banners: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (banners.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return CustomBanner(
      bannerData: banners,
      height: 180,
      onTap: (banner) {
        if(banner.selectionType == 'category'){
          // Navigator.push(context, MaterialPageRoute(builder: (context) => ModuleCategoryScreen(
          //   serviceName: banner.category?.name ?? '',
          //    moduleId:   banner.category?.module ?? '',
          // ),));
        }
        if(banner.selectionType == 'subcategory'){
          Navigator.push(context, MaterialPageRoute(builder: (context) => ModuleSubcategoryScreen(headline: banner.subcategory!.name, categoryId: banner.subcategory!.id ),));
        }
        if(banner.selectionType == 'service'){
          Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceDetailsScreen(image: '',),));
        }
      },
    );
  }

}
