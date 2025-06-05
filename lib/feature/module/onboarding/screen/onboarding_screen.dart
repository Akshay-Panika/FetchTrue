import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:bizbooster2x/core/widgets/custom_search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/costants/custom_color.dart';
import '../../../../core/costants/dimension.dart';
import '../../../../core/widgets/custom_container.dart';
import '../../../../core/widgets/custom_highlight_service.dart';
import '../../../../core/widgets/custom_service_list.dart';
import '../../../banner/widget/category_banner_widget.dart';
import '../../../category/widget/business_category_widget.dart';
import '../../../category/widget/finance_category_widget.dart';
import '../../../category/widget/franchise_category_widget.dart';
import '../../../category/widget/home_service_category_widget.dart';
import '../../../category/widget/itservice_category_widget.dart';
import '../../../category/widget/legal_service_category_widget.dart';
import '../../../category/widget/marketing_category_widget.dart';
import '../../../category/widget/module_category_widget.dart';
import '../../../education/widget/education_category_widget.dart';
import '../../../search/screen/search_screen.dart';
import '../../../service_provider/widget/service_provider_widget.dart';

class OnboardingScreen extends StatelessWidget {
  final String? moduleName;
  final String moduleId;
   OnboardingScreen({super.key, this.moduleName, required this.moduleId});


  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    final Map<String, Widget> categoryWidgets = {
      'Onboarding': ModuleCategoryWidget(moduleIndexId: moduleId),
      'Business': BusinessCategoryWidget(moduleIndexId: moduleId,),
      'Marketing': MarketingCategoryWidget(moduleIndexId: moduleId,),
      'Legal Services': LegalServiceWidget(moduleIndexId: moduleId,),
      'Home Services': HomeServiceCategoryWidget(moduleIndexId: moduleId,),
      'It Services': ItserviceCategoryWidget(moduleIndexId: moduleId,),
      'Education': EducationCategoryWidget(moduleIndexId: moduleId),
      'Finance': FinanceCategoryWidget(moduleIndexId: moduleId),
      'Franchise': FranchiseCategoryWidget(moduleIndexId: moduleId),
    };
    return Scaffold(
      appBar: CustomAppBar(title: '$moduleName'?? 'Module name', showBackButton: true, showFavoriteIcon: true,),

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
        
            SliverToBoxAdapter(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
        
                  /// banner
                  CategoryBannerWidget(),

                  categoryWidgets[moduleName] ?? SizedBox.shrink(),
                  10.height,
        
        
                  /// Services for you
                  CustomServiceList(headline: 'Services for you',),
        
                  /// Highlight service
                  CustomHighlightService(),
        
                  /// Popular Services
                  CustomServiceList(headline: 'Popular Services',),
        
                  ///  Service Provider
                  ServiceProviderWidget(),
        
                  /// Popular Services
                  Container(
                      color: CustomColor.appColor.withOpacity(0.1),
                      child: CustomServiceList(headline: 'All Services',)),
        
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


