import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/feature/category/marketing/widget/marketing_category_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/costants/custom_color.dart';
import '../../../../core/costants/text_style.dart';
import '../../../../core/widgets/custom_container.dart';
import '../../../../core/widgets/custom_search_bar.dart';
import '../../../../core/widgets/custom_sliver_appbar.dart';
import '../../../auth/user_notifier/user_notifier.dart';
import '../../../banner/widget/home_banner_widget.dart';
import '../../../banner/widget/marketing_banner_widget.dart';

class MarketingScreen extends StatefulWidget {
  final String moduleId;
  final String imageUrl;
  const MarketingScreen({super.key, required this.moduleId, required this.imageUrl});

  @override
  State<MarketingScreen> createState() => _MarketingScreenState();
}

class _MarketingScreenState extends State<MarketingScreen> {
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

          CustomSliverAppbar(
            moduleId: widget.moduleId,
            title: 'Marketing Service',
            imageUrl: widget.imageUrl,
            isCollapsed: _isCollapsed,
            searchBarHeight: searchBarHeight,
            background: MarketingBannerWidget(moduleId: widget.moduleId),
          ),

          SliverToBoxAdapter(child: MarketingCategoryWidget(moduleId: widget.moduleId,),),

          SliverToBoxAdapter(child: 500.height,)

        ],
      ),
    );
  }
}
