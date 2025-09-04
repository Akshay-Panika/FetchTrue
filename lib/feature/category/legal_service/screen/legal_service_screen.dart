import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/feature/category/legal_service/widget/legal_all_service_widget.dart';
import 'package:fetchtrue/feature/category/legal_service/widget/legal_category_widget.dart';
import 'package:fetchtrue/feature/category/legal_service/widget/legal_requirement_service_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/costants/custom_color.dart';
import '../../../../core/costants/text_style.dart';
import '../../../../core/widgets/custom_sliver_appbar.dart';
import '../../../auth/user_notifier/user_notifier.dart';
import '../../../banner/widget/legal_banner_widget.dart';
import '../../../provider/widget/provider_widget.dart';


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
    Dimensions dimensions = Dimensions(context);
    final userSession = Provider.of<UserSession>(context);
    final double searchBarHeight = dimensions.screenHeight*0.06;

    return Scaffold(
      // appBar: CustomAppBar(title: 'Legal Service',showBackButton: true,),

      body: CustomScrollView(
        controller: _scrollController,
        slivers: [

          CustomSliverAppbar(
            moduleId: widget.moduleId,
            title: 'Legal Service',
            imageUrl: widget.imageUrl,
            isCollapsed: _isCollapsed,
            searchBarHeight: searchBarHeight,
            background: LegalBannerWidget(moduleId: widget.moduleId),
          ),

          SliverToBoxAdapter(child: LegalCategoryWidget(moduleId: widget.moduleId,),),

          SliverToBoxAdapter(child: 10.height,),
          SliverToBoxAdapter(
            child: LegalRequirementServiceWidget(moduleId: widget.moduleId,),
          ),
          SliverToBoxAdapter(child: ProviderWidget(moduleId: widget.moduleId,),),

          SliverToBoxAdapter(
            child: LegalAllServiceWidget(moduleId: widget.moduleId,),
          ),

          SliverToBoxAdapter(child: 100.height,)

        ],
      ),
    );
  }
}
