import 'package:flutter/material.dart';
import '../../../../core/costants/custom_color.dart';
import '../../../../core/costants/dimension.dart';
import '../../../../core/costants/text_style.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../highlight_serive/highlight_widget.dart';
import '../../../../core/widgets/custom_search_bar.dart';
import '../../../banner/widget/category_banner_widget.dart';
import '../../../provider/widget/service_provider_widget.dart';
import '../../../search/screen/search_screen.dart';
import '../wisget/business_all_service_widget.dart';
import '../wisget/business_category_widget.dart';
import '../wisget/business_recommended_service_widget.dart';

class BusinessServiceScreen extends StatelessWidget {
  final String moduleId;
  const BusinessServiceScreen({super.key, required this.moduleId});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions =  Dimensions(context);
    final double searchBarHeight = 30;

    return Scaffold(
      body: CustomScrollView(
        slivers: [

          SliverAppBar(
            expandedHeight: 200 + searchBarHeight,
            leading: InkWell(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.arrow_back_ios,)),
            title: Text('Business Service', style: textStyle16(context,),),
            titleSpacing: 0,
            pinned: true,
            stretch: true,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Stack(
                fit: StackFit.expand,
                children: [
                 Container(
                   color: Colors.blue.withOpacity(0.3),
                 )
                ],
              ),
            ),
            bottom: PreferredSize(
                preferredSize: Size.fromHeight(searchBarHeight),
                child: CustomSearchBar()),
          ),

          SliverToBoxAdapter(child: CategoryBannerWidget(),),

          SliverToBoxAdapter(
            child: BusinessCategoryWidget(moduleIndexId: moduleId,),
          ),

          SliverToBoxAdapter(
            child: Column(
              children: [
                10.height,

                /// Services for you
                BusinessRecommendedServiceWidget(headline: 'Recommended Service', moduleIndexId: moduleId,),

                /// Highlight service
                HighlightServiceWidget(),

                ///  Service Provider
                ServiceProviderWidget(),

                /// Popular Services
                Container(
                    color: CustomColor.appColor.withOpacity(0.1),
                    child: BusinessAllServiceWidget(headline: 'All Services', moduleIndexId: moduleId,)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
