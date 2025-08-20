import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/feature/category/education/widget/education_category_widget.dart';
import 'package:fetchtrue/feature/category/it_service/widget/it_service_category_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/costants/custom_color.dart';
import '../../../../core/costants/text_style.dart';
import '../../../../core/widgets/custom_container.dart';
import '../../../../core/widgets/custom_search_bar.dart';
import '../../../auth/user_notifier/user_notifier.dart';
import '../../../banner/widget/home_banner_widget.dart';

class EducationScreen extends StatefulWidget {
  final String moduleId;
  final String imageUrl;
  const EducationScreen({super.key, required this.moduleId, required this.imageUrl});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
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
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 250 + searchBarHeight,
            pinned: true,
            stretch: true,
            backgroundColor: Colors.white,
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
                Text('Education Service', style: textStyle16(context,  color: _isCollapsed ? CustomColor.appColor : Colors.white,),),
                Text('Pune 411028, Maharashtra', style: textStyle12(context,  color: _isCollapsed ? CustomColor.descriptionColor : Colors.white,),),
              ],
            ),
            titleSpacing: 15,
            leadingWidth: 50,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: HomeBannerWidget(),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(searchBarHeight),
              child:CustomSearchBar(),
            ),
          ),

          SliverToBoxAdapter(child: EducationCategoryWidget(moduleId: widget.moduleId,),),

          SliverToBoxAdapter(child: 500.height,)

        ],
      ),
    );
  }
}
