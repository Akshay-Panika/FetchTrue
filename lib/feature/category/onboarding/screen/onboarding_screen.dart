import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/feature/category/onboarding/widget/onboarding_all_service_widget.dart';
import 'package:fetchtrue/feature/category/onboarding/widget/onboarding_category_widget.dart';
import 'package:fetchtrue/feature/category/onboarding/widget/onboarding_requirement_service_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/custom_sliver_appbar.dart';
import '../../../auth/user_notifier/user_notifier.dart';
import '../../../banner/widget/onboarding_banner_widget.dart';
import '../../../provider/widget/provider_widget.dart';

class OnboardingScreen extends StatefulWidget {
  final String moduleId;
  final String imageUrl;
  const OnboardingScreen({super.key, required this.moduleId, required this.imageUrl});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
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
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          CustomSliverAppbar(
            moduleId: widget.moduleId,
            title: 'Onboarding Service',
            imageUrl: widget.imageUrl,
            isCollapsed: _isCollapsed,
            searchBarHeight: searchBarHeight,
            background: OnboardingBannerWidget(moduleId: widget.moduleId),
          ),

          SliverToBoxAdapter(child: OnboardingCategoryWidget(moduleId: widget.moduleId,),),

          SliverToBoxAdapter(child: 10.height,),
          SliverToBoxAdapter(
            child: OnboardingRequirementServiceWidget(moduleId: widget.moduleId,),
          ),
          SliverToBoxAdapter(child: ProviderWidget(moduleId: widget.moduleId,),),

          SliverToBoxAdapter(
            child: OnboardingAllServiceWidget(moduleId: widget.moduleId,),
          ),

          SliverToBoxAdapter(child: 100.height,)
        ],
      ),
    );
  }
}
