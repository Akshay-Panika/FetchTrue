import 'package:fetchtrue/core/costants/dimension.dart';
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

class CustomHomeSliverAppbarWidget extends StatelessWidget {
  final double searchBarHeight;
  final bool isCollapsed;
  final Widget background;

  const CustomHomeSliverAppbarWidget({
    super.key,
    required this.searchBarHeight,
    required this.isCollapsed,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    final userSession = Provider.of<UserSession>(context);
    final _isLogIn = userSession.isLoggedIn;

    if (!_isLogIn) {
      return _buildSliverAppBar(
        context,
        isCollapsed,
        background,
        name: "Guest",
        photo: null,
      );
    }

    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserInitial) {
          if (userSession.userId != null) {
            context.read<UserBloc>().add(GetUserById(userSession.userId!));
          }
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        } else if (state is UserLoading) {
          return  SliverToBoxAdapter(child: _profileShimmer(),);
        } else if (state is UserLoaded) {
          final user = state.user;
          return _buildSliverAppBar(
            context, isCollapsed, background,
            name: user.fullName ?? "Guest",
            photo: user.profilePhoto,
            packageActive: user.packageActive,
          );
        } else if (state is UserError) {
          print("Error: ${state.massage}");
          return _buildSliverAppBar( context, isCollapsed, background, name: "Guest", photo: null,
          );
        }
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }

  SliverAppBar _buildSliverAppBar(
      BuildContext context,
      bool isCollapsed,
      Widget background, {
        required String name,
        String? photo,
        bool? packageActive,
      }) {
    return SliverAppBar(
      expandedHeight: 250 + searchBarHeight,
      pinned: true,
      stretch: true,
      elevation: isCollapsed ? 0.2 : 0,
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
                  ? NetworkImage(photo) : AssetImage(CustomImage.nullImage),
            ),
          ),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: textStyle16(context, color: isCollapsed ? CustomColor.appColor : Colors.white,),
            child: Text(name),
          ),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: textStyle12(context, color: isCollapsed ? CustomColor.descriptionColor : Colors.white,),
            child: const Text('Pune, Maharashtra'),
          ),
        ],
      ),
      titleSpacing: 15,
      leadingWidth: 50,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: background,
      ),
      actions: [
        InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PackageScreen()),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            decoration: BoxDecoration(
              border:
              Border.all(color: CustomColor.appColor, width: 0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                 Icon(Icons.verified_outlined, size: 16),
                10.width,
                 Text(
                   packageActive == true ? 'GP':'Package',
                  style: textStyle12(context, fontWeight: FontWeight.w600,
                    color:isCollapsed ? CustomColor.appColor : Colors.white,
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
          icon:  Icon(
            Icons.notifications_active_outlined,
            color: isCollapsed ? CustomColor.iconColor : Colors.white,
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(searchBarHeight),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: CustomSearchBar(),
        ),
      ),
    );
  }
}


Widget _profileShimmer(){
  return Container(
    height: 350,
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
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CustomSearchBar(),
          ),
        ],
      ),
    ),
  );
}