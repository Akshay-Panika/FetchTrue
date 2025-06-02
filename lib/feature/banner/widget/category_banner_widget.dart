import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/widgets/custom_banner.dart';
import '../../../helper/api_helper.dart';
import '../bloc/module_banner/module_banner_bloc.dart';
import '../bloc/module_banner/module_banner_event.dart';
import '../bloc/module_banner/module_banner_state.dart';
import '../repository/banner_service.dart';
import 'home_banner_widget.dart';
import '../../service/screen/service_details_screen.dart';
import '../../category/screen/module_subcategory_screen.dart';

class CategoryBannerWidget extends StatefulWidget {
  const CategoryBannerWidget({super.key});

  @override
  State<CategoryBannerWidget> createState() => _CategoryBannerWidgetState();
}

class _CategoryBannerWidgetState extends State<CategoryBannerWidget> {

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

            final banner = state.moduleBannerModel;
            // final banner = state.moduleBannerModel.where((moduleBanner) =>
            // moduleBanner.page == 'category'
            // ).toList();

            if (banner.isEmpty) {
              return const Center(child: Text('No banner found.'));
            }

            return CustomBanner(
              bannerData: banner,
              height: 200,
              onTap: (banner) {
                if(banner.selectionType == 'subcategory'){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ModuleSubcategoryScreen(
                    // categoryId:banner.subcategory!.categoryId ?? '',
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
