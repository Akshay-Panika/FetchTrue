import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/feature/category/legal_service/widget/legal_category_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/costants/custom_color.dart';
import '../../../../core/costants/text_style.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/custom_container.dart';
import '../../../../core/widgets/custom_network_mage.dart';
import '../../../auth/user_notifier/user_notifier.dart';
import '../../../banner/widget/legal_banner_widget.dart';
import '../../../favorite/screen/favorite_screen.dart';
import '../../../highlight_serive/highlight_widget.dart';
import '../../../../core/widgets/custom_search_bar.dart';
import '../../../../core/widgets/custom_service_list.dart';
import '../../../provider/widget/service_provider_widget.dart';
import '../../../search/screen/search_screen.dart';

class LegalServiceScreen extends StatefulWidget {
  final String moduleId;
  final String imageUrl;
  const LegalServiceScreen({super.key, required this.moduleId, required this.imageUrl});

  @override
  State<LegalServiceScreen> createState() => _LegalServiceScreenState();
}

class _LegalServiceScreenState extends State<LegalServiceScreen> {

  final ScrollController _scrollController = ScrollController();
  bool _isCollapsed = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    final isCollapsed = _scrollController.offset > 150;
    if (isCollapsed != _isCollapsed) {
      setState(() => _isCollapsed = isCollapsed);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userSession = Provider.of<UserSession>(context);

    final double searchBarHeight = 50;

    return Scaffold(
      // appBar: CustomAppBar(title: 'Legal Service',showBackButton: true,),

      body: CustomScrollView(
        controller: _scrollController,
        slivers: [

          SliverAppBar(
            expandedHeight: 200 + searchBarHeight,
            leading: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Hero(
                tag: widget.moduleId,
                child: Material(
                  color: Colors.transparent,
                  child: CircleAvatar(radius: 20.5,
                    backgroundColor: CustomColor.appColor,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: CustomColor.whiteColor,
                      backgroundImage: NetworkImage(widget.imageUrl),
                    ),
                  ),
                ),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Legal Service', style: textStyle16(context,  color: _isCollapsed ? CustomColor.appColor : Colors.white,),),
                Text('Pune 411028, Maharashtra', style: textStyle12(context,  color: _isCollapsed ? CustomColor.descriptionColor : Colors.white,),),
              ],
            ),
            titleSpacing: 15,
            leadingWidth: 50,
            pinned: true,
            stretch: true,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    CustomColor.appColor,
                    CustomColor.whiteColor
                  ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter
                  )
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    30.height,
                    CircleAvatar(radius: 30,
                      child: Image.asset('assets/image/legal_img.png', height: 50,),
                      backgroundColor: CustomColor.whiteColor,),
                    10.height,
                    Text('Your Trusted Leagal Partner', style: textStyle14(context, color: CustomColor.appColor),),
                    Text('One Stop for leagal & business soltuion', style: textStyle12(context, color: CustomColor.descriptionColor),),
                  ],
                ),
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

          SliverToBoxAdapter(child: LegalBannerWidget(moduleId: widget.moduleId,),),

          SliverToBoxAdapter(child: LegalCategoryWidget(moduleId: widget.moduleId,),),

          SliverToBoxAdapter(child: 500.height,)

        ],
      ),
    );
  }
}
