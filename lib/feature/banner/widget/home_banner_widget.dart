// import 'package:bizbooster2x/feature/service/screen/service_details_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:shimmer/shimmer.dart';
// import '../../../core/costants/custom_color.dart';
// import '../../../core/widgets/custom_banner.dart';
// import '../../../core/widgets/custom_container.dart';
// import '../../../helper/api_helper.dart';
// import '../../category/screen/module_subcategory_screen.dart';
// import '../../home/model/banner_model.dart';
// class HomeBannerWidget extends StatefulWidget {
//   const HomeBannerWidget({super.key});
//
//   @override
//   State<HomeBannerWidget> createState() => _HomeBannerWidgetState();
// }
//
// class _HomeBannerWidgetState extends State<HomeBannerWidget> {
//
//
//   Future<List<ModuleBannerModel>> _homeBanners() async {
//     final fetched = await BannerService.fetchBanners();
//     return fetched.where((b) => b.page == 'home').toList();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return FutureBuilder<List<ModuleBannerModel>>(
//         future: _homeBanners(),
//         builder: (context, snapshot) {
//
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const HomeBannerShimmerWidget();
//           }
//
//           else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const SizedBox.shrink();
//           }
//
//           else if (snapshot.hasData || snapshot.data!.isNotEmpty) {
//             final banners = snapshot.data!;
//
//             return CustomBanner(
//               bannerData: banners,
//               height: 180,
//               onTap: (banner) {
//                 if(banner.selectionType == 'subcategory'){
//                   Navigator.push(context, MaterialPageRoute(builder: (context) => ModuleSubcategoryScreen(
//                     categoryId: banner.subcategory?.category ?? '',
//                   ),
//                   ));
//                 }
//                 if(banner.selectionType == 'service'){
//                   Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceDetailsScreen(image: '',),));
//                 }
//               },
//             );
//           }
//
//           else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//
//           else{
//             return const Center(child: Text('No banner'));
//           }
//
//         },);
//
//   }
//
// }
//
//
//
//
//
//
//
//
//
//
//
//
//
// class HomeBannerShimmerWidget extends StatelessWidget {
//   const HomeBannerShimmerWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey.shade300,
//       highlightColor: Colors.grey.shade100,
//       child: Column(
//         children: [
//           CustomContainer(
//               height: 160,
//               backgroundColor: CustomColor.whiteColor
//           ),
//
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               CustomContainer(
//                   margin: const EdgeInsets.symmetric(horizontal: 3),
//                   height: 5,
//                   width: 24,
//                   backgroundColor: CustomColor.whiteColor
//               ),
//               CustomContainer(
//                   margin: const EdgeInsets.symmetric(horizontal: 3),
//                   height: 5,
//                   width: 10,
//                   backgroundColor: CustomColor.whiteColor
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
