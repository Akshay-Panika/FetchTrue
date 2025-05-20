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
        banners = fetched.where((b) => b.page == 'category').toList(); // filter by 'home' page
      });
    } catch (e) {
      debugPrint('Error loading banners: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (banners.isEmpty) {
      return const Center(child: SizedBox());
    }

    return CustomBanner(
      bannerData: banners,
      height: 180,
      onTap: (banner) {

      },
    );
  }
}
