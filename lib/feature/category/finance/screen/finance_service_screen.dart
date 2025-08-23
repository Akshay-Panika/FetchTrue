import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/costants/custom_color.dart';
import '../../../../core/costants/text_style.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/custom_sliver_appbar.dart';
import '../../../auth/user_notifier/user_notifier.dart';
import '../../../banner/widget/finance_banner_widget.dart';
import '../../../banner/widget/franchise_banner_widget.dart';
import '../../../favorite/screen/favorite_screen.dart';
import '../../../../core/widgets/custom_search_bar.dart';
import '../../../search/screen/search_screen.dart';
import '../widget/finance_category_widget.dart';


class FinanceServiceScreen extends StatefulWidget {
  final String moduleId;
  final String imageUrl;
  const FinanceServiceScreen({super.key, required this.moduleId, required this.imageUrl});

  @override
  State<FinanceServiceScreen> createState() => _FinanceServiceScreenState();
}

class _FinanceServiceScreenState extends State<FinanceServiceScreen> {

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
      body: SafeArea(
        child: CustomScrollView(
          slivers: [

            CustomSliverAppbar(
              moduleId: widget.moduleId,
              title: 'Finance Service',
              imageUrl: widget.imageUrl,
              isCollapsed: _isCollapsed,
              searchBarHeight: searchBarHeight,
              background: FinanceBannerWidget(moduleId: widget.moduleId),
            ),


            SliverToBoxAdapter(
              child: FinanceCategoryWidget(moduleId: widget.moduleId),
            ),
          ],
        ),
      ),
    );
  }
}
