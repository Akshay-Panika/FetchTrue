// import 'package:flutter/material.dart';
// import '../../../core/widgets/custom_banner.dart';
// import '../../../helper/api_helper.dart';
// import '../repository/banner_service.dart';
// import 'home_banner_widget.dart';
// import '../../home/model/banner_model.dart';
// import '../../service/screen/service_details_screen.dart';
// import '../../category/screen/module_subcategory_screen.dart';
//
// class CategoryBannerWidget extends StatefulWidget {
//   const CategoryBannerWidget({super.key});
//
//   @override
//   State<CategoryBannerWidget> createState() => _CategoryBannerWidgetState();
// }
//
// class _CategoryBannerWidgetState extends State<CategoryBannerWidget> {
//   // Future<List<BannerModel>> _homeBanners() async {
//   //   final fetched = await BannerService.fetchBanners();
//   //   return fetched.where((b) => b.page == 'category').toList();
//   // }
//
//   Future<List<ModuleBannerModel>> _homeBanners() async {
//     final fetched = await BannerService.fetchBanners();
//     return fetched.where((b) => b.page == 'category').toList();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return FutureBuilder<List<ModuleBannerModel>>(
//       future: _homeBanners(),
//       builder: (context, snapshot) {
//
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const HomeBannerShimmerWidget();
//         }
//
//         else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return const SizedBox.shrink();
//         }
//
//         else if (snapshot.hasData || snapshot.data!.isNotEmpty) {
//           final banners = snapshot.data!;
//           return CustomBanner(
//             bannerData: banners,
//             height: 180,
//             onTap: (banner) {
//               if(banner.selectionType == 'subcategory'){
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => ModuleSubcategoryScreen(
//                   categoryId: banner.subcategory?.category ?? '',
//                 ),
//                 ));
//               }
//               if(banner.selectionType == 'service'){
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceDetailsScreen(image: '',),));
//               }
//             },
//           );
//         }
//
//         else if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         }
//
//         else{
//           return const Center(child: Text('No banner'));
//         }
//
//       },);
//
//   }
// }
