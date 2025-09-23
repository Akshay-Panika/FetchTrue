import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/feature/category/business/widget/business_all_service_widget.dart';
import 'package:fetchtrue/feature/category/business/widget/business_requirement_service_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/custom_sliver_appbar.dart';
import '../../../auth/user_notifier/user_notifier.dart';
import '../../../banner/widget/business_banner_widget.dart';
import '../../../highlight_serive/highlight_widget.dart';
import '../../../provider/bloc/provider/provider_bloc.dart';
import '../../../provider/bloc/provider/provider_event.dart';
import '../../../provider/repository/provider_repository.dart';
import '../../../provider/widget/provider_category_widget.dart';
import '../../../provider/widget/provider_widget.dart';
import '../widget/business_category_widget.dart';

class BusinessScreen extends StatefulWidget {
  final String moduleId;
  final String imageUrl;
  const BusinessScreen({super.key, required this.moduleId, required this.imageUrl});

  @override
  State<BusinessScreen> createState() => _BusinessScreenState();
}

class _BusinessScreenState extends State<BusinessScreen> {
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

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ProviderBloc(ProviderRepository())..add(GetProviders()),
        ),
      ],
      child: Scaffold(
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            CustomSliverAppbar(
              moduleId: widget.moduleId,
              title: 'Business Service',
              imageUrl: widget.imageUrl,
              isCollapsed: _isCollapsed,
              searchBarHeight: searchBarHeight,
              background: BusinessBannerWidget(moduleId: widget.moduleId),
            ),

            SliverToBoxAdapter(child: BusinessCategoryWidget(moduleId: widget.moduleId,),),

            SliverToBoxAdapter(child: 10.height,),
            SliverToBoxAdapter(child: HighlightServiceWidget(moduleId: widget.moduleId,),),
            SliverToBoxAdapter(
              child: BusinessRequirementServiceWidget(moduleId: widget.moduleId,),
            ),
            SliverToBoxAdapter(child: ProviderWidget(moduleId: widget.moduleId,),),
            SliverToBoxAdapter(child: BusinessAllServiceWidget(moduleId: widget.moduleId,),),
            /// Provider Store
            ...ProviderCategoryWidget.slivers(widget.moduleId),
            SliverToBoxAdapter(child: 100.height,)

          ],
        ),
      ),
    );
  }
}
