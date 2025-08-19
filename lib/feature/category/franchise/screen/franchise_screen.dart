import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/costants/custom_color.dart';
import '../../../../core/costants/dimension.dart';
import '../../../../core/widgets/custom_container.dart';
import '../../../auth/user_notifier/user_notifier.dart';
import '../../../banner/widget/franchise_banner_widget.dart';
import '../../../favorite/screen/favorite_screen.dart';
import '../../../highlight_serive/highlight_widget.dart';
import '../../../../core/widgets/custom_search_bar.dart';
import '../../../provider/widget/service_provider_widget.dart';
import '../../../search/screen/search_screen.dart';
import '../widget/franchise_all_service_widget.dart';
import '../widget/franchise_category_widget.dart';
import '../widget/franchise_recommended_service_widget.dart';


class FranchiseScreen extends StatelessWidget {
  final String moduleId;
  const FranchiseScreen({super.key, required this.moduleId});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    final userSession = Provider.of<UserSession>(context);

    final double searchBarHeight = 30;

    return Scaffold(

      body: CustomScrollView(
        slivers: [

          SliverAppBar(
            expandedHeight: 160 + searchBarHeight,
            leading: InkWell(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.arrow_back_ios, color: CustomColor.whiteColor,size: 18,)),
            title: Text('Franchise Service', style: textStyle16(context, color: CustomColor.whiteColor),),
            titleSpacing: 0,
            pinned: true,
            stretch: true,
            backgroundColor: Color(0xff1A434E),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Stack(
                fit: StackFit.expand,
                children: [
                   Padding(
                     padding: const EdgeInsets.only(left: 15.0, right: 15,top: 15),
                     child: Center(child: Text('Franchise your business and reach customers across every region.',
                     style: textStyle16(context, color: CustomColor.whiteColor,fontWeight: FontWeight.w400),)),
                   )
                ],
              ),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(searchBarHeight),
              child: Row(
                children: [
                  Expanded(
                    child: CustomSearchBar(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => SearchScreen()),
                      ),
                    ),
                  ),

                  CustomContainer(
                    border: true,
                    borderColor: CustomColor.appColor,
                    color: CustomColor.whiteColor,
                    padding: EdgeInsets.all(8),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FavoriteScreen(userId: userSession.userId),)),
                    child: Icon(Icons.favorite, color: Colors.red,),)
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: FranchiseBannerWidget(moduleId: moduleId,),
          ),

          /// Category
          SliverToBoxAdapter(
            child: FranchiseCategoryWidget(moduleIndexId: moduleId),
          ),

          // SliverToBoxAdapter(
          //   child: Column(
          //     children: [
          //       10.height,
          //
          //       /// Services for you
          //       FranchiseRecommendedServiceWidget(headline: 'Recommended Service', moduleIndexId: moduleId,),
          //
          //       /// Highlight service
          //       HighlightServiceWidget(),
          //
          //       ///  Service Provider
          //       ServiceProviderWidget(),
          //
          //       /// Popular Services
          //       Container(
          //           color: CustomColor.appColor.withOpacity(0.1),
          //           child: FranchiseAllServiceWidget(headline: 'All Services', moduleIndexId: moduleId,)),
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }
}
