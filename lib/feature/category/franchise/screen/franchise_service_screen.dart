import 'package:flutter/material.dart';
import '../../../../core/costants/custom_color.dart';
import '../../../../core/costants/dimension.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../highlight_serive/highlight_widget.dart';
import '../../../../core/widgets/custom_search_bar.dart';
import '../../../../core/widgets/custom_service_list.dart';
import '../../../banner/widget/category_banner_widget.dart';
import '../../../provider/widget/service_provider_widget.dart';
import '../../../search/screen/search_screen.dart';
import '../wisget/franchise_all_service_widget.dart';
import '../wisget/franchise_category_widget.dart';
import '../wisget/franchise_recommended_service_widget.dart';

class FranchiseServiceScreen extends StatelessWidget {
  final String moduleId;
  const FranchiseServiceScreen({super.key, required this.moduleId});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return Scaffold(
      appBar: CustomAppBar(title: 'Franchise Service', showBackButton: true,),

      body: SafeArea(
        child: CustomScrollView(
          slivers: [
        
            /// Banner
            SliverToBoxAdapter(child: CategoryBannerWidget(),),
        
            /// Search bar
            SliverAppBar(
              toolbarHeight: 60,
              floating: true,
              backgroundColor: CustomColor.canvasColor,
              automaticallyImplyLeading: false,
              flexibleSpace:  CustomSearchBar(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen(),)),),
            ),
        
            /// Category
            SliverToBoxAdapter(
              child: FranchiseCategoryWidget(moduleIndexId: moduleId),
            ),
        
            SliverToBoxAdapter(
              child: Column(
                children: [
                  10.height,
                  
                  /// Services for you
                  FranchiseRecommendedServiceWidget(headline: 'Recommended Service', moduleIndexId: moduleId,),
        
                  /// Highlight service
                  HighlightServiceWidget(),

                  ///  Service Provider
                  ServiceProviderWidget(),
        
                  /// Popular Services
                  Container(
                      color: CustomColor.appColor.withOpacity(0.1),
                      child: FranchiseAllServiceWidget(headline: 'All Services', moduleIndexId: moduleId,)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
