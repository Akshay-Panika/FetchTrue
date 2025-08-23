import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/costants/custom_color.dart';
import '../../../../core/costants/dimension.dart';
import '../../../../core/widgets/custom_container.dart';
import '../../../../core/widgets/custom_sliver_appbar.dart';
import '../../../auth/user_notifier/user_notifier.dart';
import '../../../banner/widget/franchise_banner_widget.dart';
import '../../../favorite/screen/favorite_screen.dart';
import '../../../../core/widgets/custom_search_bar.dart';
import '../../../search/screen/search_screen.dart';
import '../widget/franchise_category_widget.dart';


class FranchiseScreen extends StatefulWidget {
  final String moduleId;
  final String imageUrl;
  const FranchiseScreen({super.key, required this.moduleId, required this.imageUrl});

  @override
  State<FranchiseScreen> createState() => _FranchiseScreenState();
}

class _FranchiseScreenState extends State<FranchiseScreen> {

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
    Dimensions dimensions = Dimensions(context);
    final userSession = Provider.of<UserSession>(context);

    final double searchBarHeight = 50;

    return Scaffold(

      body: CustomScrollView(
        controller: _scrollController,
        slivers: [

          CustomSliverAppbar(
            moduleId: widget.moduleId,
            title: 'Franchise Service',
            imageUrl: widget.imageUrl,
            isCollapsed: _isCollapsed,
            searchBarHeight: searchBarHeight,
            background: FranchiseBannerWidget(moduleId: widget.moduleId),
          ),


          /// Category
          SliverToBoxAdapter(
            child: FranchiseCategoryWidget(moduleIndexId: widget.moduleId),
          ),


          SliverToBoxAdapter(child: 500.height,)
        ],
      ),
    );
  }
}
