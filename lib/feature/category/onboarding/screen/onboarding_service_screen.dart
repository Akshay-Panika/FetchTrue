import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/material.dart';
import '../../../../core/costants/custom_color.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../highlight_serive/highlight_widget.dart';
import '../../../../core/widgets/custom_search_bar.dart';
import '../../../../core/widgets/custom_service_list.dart';
import '../../../banner/widget/category_banner_widget.dart';
import '../../../provider/widget/service_provider_widget.dart';
import '../../../search/screen/search_screen.dart';
import '../wisget/onboarding_all_service_widget.dart';
import '../wisget/onboarding_category_widget.dart';
import '../wisget/onboarding_recommended_service_widget.dart';


class OnboardingServiceScreen extends StatelessWidget {
  final String moduleId;
  const OnboardingServiceScreen({super.key, required this.moduleId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Onboarding Service', showBackButton: true,),

      body: SafeArea(
        child: CustomScrollView(
          slivers: [

            SliverAppBar(
              toolbarHeight: 60,
              floating: true,
              backgroundColor: CustomColor.canvasColor,
              automaticallyImplyLeading: false,
              flexibleSpace:  CustomSearchBar(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen(),)),),
            ),


            SliverToBoxAdapter(child: CategoryBannerWidget(),),

            SliverToBoxAdapter(
              child: OnboardingCategoryWidget(moduleId: moduleId),
            ),

            SliverToBoxAdapter(
              child: Column(
                children: [
                  10.height,

                  /// Services for you
                  OnboardingRecommendedServiceWidget(headline: 'Recommended Service',moduleIndexId: moduleId,),

                  /// Highlight service
                  HighlightServiceWidget(),

                  ///  Service Provider
                  ServiceProviderWidget(),

                  /// Popular Services
                  Container(
                      color: CustomColor.appColor.withOpacity(0.1),
                      child: OnboardingAllServiceWidget(headline: 'All Services', moduleIndexId: moduleId,)),
                ],
              ),
            )

          ],
        ),
      ),
    );
  }
}
