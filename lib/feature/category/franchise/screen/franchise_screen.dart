import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/costants/custom_color.dart';
import '../../../../core/costants/dimension.dart';
import '../../../../core/widgets/custom_container.dart';
import '../../../auth/user_notifier/user_notifier.dart';
import '../../../banner/widget/franchise_banner_widget.dart';
import '../../../favorite/screen/favorite_screen.dart';
import '../../../../core/widgets/custom_search_bar.dart';
import '../../../search/screen/search_screen.dart';
import '../widget/franchise_category_widget.dart';


class FranchiseScreen extends StatelessWidget {
  final String moduleId;
  final String imageUrl;
  const FranchiseScreen({super.key, required this.moduleId, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    final userSession = Provider.of<UserSession>(context);

    final double searchBarHeight = 50;

    return Scaffold(

      body: CustomScrollView(
        slivers: [

          SliverAppBar(
            expandedHeight: 160 + searchBarHeight,
            leading: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Hero(
                tag: moduleId,
                child: Material(
                  color: Colors.transparent,
                  child: CircleAvatar(radius: 20.5,
                    backgroundColor: CustomColor.appColor,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: CustomColor.whiteColor,
                      backgroundImage: NetworkImage(imageUrl),
                    ),
                  ),
                ),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Franchise Service', style: textStyle16(context, color: CustomColor.whiteColor),),
                Text('Pune 411028, Maharashtra', style: textStyle12(context, color: CustomColor.whiteColor),),
              ],
            ),
            titleSpacing: 15,
            leadingWidth: 50,
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


          SliverToBoxAdapter(child: 500.height,)
        ],
      ),
    );
  }
}
