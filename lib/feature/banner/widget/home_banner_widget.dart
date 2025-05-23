import 'package:bizbooster2x/feature/banner/bloc/module_banner/module_banner_bloc.dart';
import 'package:bizbooster2x/feature/banner/bloc/module_banner/module_banner_event.dart';
import 'package:bizbooster2x/feature/banner/bloc/module_banner/module_banner_state.dart';
import 'package:bizbooster2x/feature/service/screen/service_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/widgets/custom_banner.dart';
import '../../../core/widgets/custom_container.dart';
import '../../category/screen/module_subcategory_screen.dart';
import '../repository/banner_service.dart';
class HomeBannerWidget extends StatefulWidget {
  const HomeBannerWidget({super.key});

  @override
  State<HomeBannerWidget> createState() => _HomeBannerWidgetState();
}

class _HomeBannerWidgetState extends State<HomeBannerWidget> {



  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (_) => ModuleBannerBloc(BannerService())..add(GetModuleBanner()),
      child:  BlocBuilder<ModuleBannerBloc, ModuleBannerState>(
        builder: (context, state) {
          if (state is ModuleBannerLoading) {
            return HomeBannerShimmerWidget();
          }

          else if(state is ModuleBannerLoaded){

            // final banner = state.moduleBannerModel;
            final banner = state.moduleBannerModel.where((moduleBanner) =>
            moduleBanner.page == 'home'
            ).toList();

            if (banner.isEmpty) {
              return const Center(child: Text('No banner found.'));
            }

            return CustomBanner(
              bannerData: banner,
              height: 180,
              onTap: (banner) {
                if(banner.selectionType == 'subcategory'){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ModuleSubcategoryScreen(
                    categoryId:banner.subcategory!.categoryId ?? '',
                  ),
                  ));
                }
                if(banner.selectionType == 'service'){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceDetailsScreen(
                   serviceId: banner.id,
                    ),));
                }
              },
            );

          }

          else if (state is ModuleBannerError) {
            return Center(child: Text(state.errorMessage));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

}













class HomeBannerShimmerWidget extends StatelessWidget {
  const HomeBannerShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: [
          CustomContainer(
              height: 160,
              backgroundColor: CustomColor.whiteColor
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomContainer(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  height: 5,
                  width: 24,
                  backgroundColor: CustomColor.whiteColor
              ),
              CustomContainer(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  height: 5,
                  width: 10,
                  backgroundColor: CustomColor.whiteColor
              ),
            ],
          ),
        ],
      ),
    );
  }
}
