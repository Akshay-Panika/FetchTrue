import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import '../../../../core/costants/custom_color.dart';
import '../../../../core/widgets/custom_highlight_service.dart';
import '../../../../core/widgets/custom_search_bar.dart';
import '../../../../core/widgets/custom_service_list.dart';
import '../../../banner/widget/category_banner_widget.dart';
import '../../../provider/widget/service_provider_widget.dart';
import '../../../search/screen/search_screen.dart';
import '../wisget/franchise_category_widget.dart';

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
