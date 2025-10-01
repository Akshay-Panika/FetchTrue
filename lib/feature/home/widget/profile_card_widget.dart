import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/feature/banner/widget/home_banner_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_search_bar.dart';
import '../../../core/widgets/shimmer_box.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../../notification/screen/notification_screen.dart';
import '../../package/screen/package_screen.dart';
import '../../profile/bloc/user/user_event.dart';
import '../../profile/bloc/user/user_bloc.dart';
import '../../profile/bloc/user/user_state.dart';

class CustomHomeSliverAppbarWidget extends StatefulWidget {
  final double searchBarHeight;
  final bool isCollapsed;

  const CustomHomeSliverAppbarWidget({
    super.key,
    required this.searchBarHeight,
    required this.isCollapsed,
  });

  @override
  State<CustomHomeSliverAppbarWidget> createState() =>
      _CustomHomeSliverAppbarWidgetState();
}

class _CustomHomeSliverAppbarWidgetState
    extends State<CustomHomeSliverAppbarWidget> {
  bool _bannerAvailable = true; // default false

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);

    final userSession = Provider.of<UserSession>(context);
    final _isLogIn = userSession.isLoggedIn;

    if (!_isLogIn) {
      return _buildSliverAppBar(
        context,
        widget.isCollapsed,
        name: "Guest",
        photo: null,
      );
    }

    return BlocBuilder<UserBloc, UserState>(
      buildWhen: (previous, current) {
        return !(previous is UserLoaded && current is UserLoading);
      },
      builder: (context, state) {

         if (state is UserLoading) {
          return SliverToBoxAdapter(child: _profileShimmer(dimensions));
        }

          if (state is UserLoaded) {
          final user = state.user;
          return _buildSliverAppBar(
            context,
            widget.isCollapsed,
            name: user.fullName ?? "Guest",
            photo: user.profilePhoto,
            packageActive: user.packageActive,
            packageStatus: user.packageStatus,
          );
        } else if (state is UserError) {
          debugPrint("Error: ${state.massage}");
          return _buildSliverAppBar(
            context,
            widget.isCollapsed,
            name: "Guest",
            photo: null,
          );
        }
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }

  SliverAppBar _buildSliverAppBar(
      BuildContext context,
      bool isCollapsed, {
        required String name,
        String? photo,
        bool? packageActive,
        String? packageStatus,
      }) {
    Dimensions dimensions = Dimensions(context);

    return SliverAppBar(
      expandedHeight: (_bannerAvailable ? dimensions.screenHeight*0.25 : 0) + widget.searchBarHeight,
      pinned: true,
      stretch: true,
      elevation: 0,
      // elevation: isCollapsed ? 0.2 : 0,
      shadowColor: Colors.black26,
      backgroundColor: Colors.white,
      leading: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Material(
          color: Colors.transparent,
          child: CircleAvatar(
            radius: 20.5,
            backgroundColor: CustomColor.appColor,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: CustomColor.whiteColor,
              backgroundImage: (photo != null && photo.isNotEmpty)
                  ? NetworkImage(photo)
                  : AssetImage(CustomImage.nullImage) as ImageProvider,
            ),
          ),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: textStyle14(
              context,
              color: (!_bannerAvailable || isCollapsed) ? CustomColor.appColor : Colors.white,
            ),
            child: Text(name),
          ),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: textStyle12(
              context,
              color:
              (!_bannerAvailable || isCollapsed) ? CustomColor.descriptionColor : Colors.white,
            ),
            child: const Text('Pune, Maharashtra'),
          ),
        ],
      ),
      titleSpacing: 15,
      leadingWidth: 50,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration:  BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white,
                    Colors.grey.shade100,
                  ],
                ),
              ),
            ),
            HomeBannerWidget(
              onStatus: (status) {
                if (_bannerAvailable != status) {
                  setState(() {
                    _bannerAvailable = status; // yahan control ho raha hai
                  });
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PackageScreen()),
          ),
          child: Container(
            padding:  EdgeInsets.symmetric(vertical: dimensions.screenHeight*0.005, horizontal: dimensions.screenHeight*0.015),
            decoration: BoxDecoration(
              border: Border.all(color: CustomColor.appColor, width: 0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.verified_outlined, size: 14,
                  color: (!_bannerAvailable || isCollapsed) ? CustomColor.appColor : Colors.white,
                ),
                10.width,
                Text(
                  packageActive == true ? '${packageStatus}' : 'Package',
                  style: textStyle12(
                    context,
                    color: (!_bannerAvailable || isCollapsed)
                        ? CustomColor.appColor
                        : Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        10.width,
        IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NotificationScreen()),
          ),
          icon: Icon(
            Icons.notifications_active_outlined,
            color: (!_bannerAvailable || isCollapsed) ? CustomColor.iconColor : Colors.white,
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(widget.searchBarHeight),
        child:  Padding(
          padding: EdgeInsets.symmetric(horizontal: dimensions.screenHeight*0.012, vertical: dimensions.screenHeight*0.006),
          child: CustomSearchBar(moduleId: '',),
        ),
      ),
    );
  }
}


Widget _profileShimmer(Dimensions dimensions){

  return Container(
    height: dimensions.screenHeight*0.35,
    child: Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50.0,horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(backgroundColor: CustomColor.whiteColor,),
                    10.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        5.height,
                        ShimmerBox(height: 10, width: 80),
                        5.height,
                        ShimmerBox(height: 10, width: 150),
                      ],
                    )
                  ],
                ),

                Row(
                  children: [
                    ShimmerBox(height: 30, width: 60),
                    10.width,
                    ShimmerBox(height: 25, width: 20),
                    10.width,
                  ],
                )
              ],
            ),
          ),

          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 8.0),
            child: CustomSearchBar(moduleId: '',),
          ),
        ],
      ),
    ),
  );
}