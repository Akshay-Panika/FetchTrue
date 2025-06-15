import 'package:bizbooster2x/feature/banner/bloc/module_banner/module_banner_bloc.dart';
import 'package:bizbooster2x/feature/banner/bloc/module_banner/module_banner_event.dart';
import 'package:bizbooster2x/feature/banner/bloc/module_banner/module_banner_state.dart';
import 'package:bizbooster2x/feature/service/screen/service_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/widgets/custom_banner.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_url_launch.dart';
import '../../subcategory/screen/subcategory_screen.dart';
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
              height: 200,
                onTap: (banner) {
                  if (banner.selectionType == 'subcategory') {
                    Navigator.push(context, MaterialPageRoute(builder: (_) =>
                        SubcategoryScreen(categoryId: banner.subcategory?.categoryId ?? '',categoryName: banner.subcategory!.name,),),
                    );
                  }
                  else if (banner.selectionType == 'service') {
                    Navigator.push(context, MaterialPageRoute(builder: (_) =>
                        ServiceDetailsScreen(serviceId: banner.service ?? '',),
                      ),
                    );
                  }
                  else if (banner.selectionType == 'url') {
                    // CustomUrlLaunch(banner.url ?? '');
                  }
                  else {
                    print('No valid action');
                  }
                }
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
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Center(
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: CustomContainer(
                height: 180,
                backgroundColor: CustomColor.whiteColor
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomContainer(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  height: 5,
                  width: 24,
                  backgroundColor: CustomColor.greyColor.withOpacity(0.2)
              ),
              CustomContainer(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  height: 5,
                  width: 10,
                  backgroundColor: CustomColor.descriptionColor.withOpacity(0.1)
              ),

              CustomContainer(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  height: 5,
                  width: 10,
                  backgroundColor: CustomColor.descriptionColor.withOpacity(0.1)
              ),
            ],
          ),
        ),
      ],
    );
  }
}

