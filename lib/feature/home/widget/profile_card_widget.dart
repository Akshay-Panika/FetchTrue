import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/feature/favorite/screen/favorite_screen.dart';
import 'package:fetchtrue/feature/my_lead/screen/leads_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/costants/text_style.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../../notification/screen/notification_screen.dart';
import '../../package/screen/package_screen.dart';
import '../../profile/bloc/user/user_event.dart';
import '../../profile/bloc/user/user_bloc.dart';
import '../../profile/bloc/user/user_state.dart';

class ProfileAppWidget extends StatelessWidget {
  const ProfileAppWidget({super.key,});


  @override
  Widget build(BuildContext context) {
    final userSession = Provider.of<UserSession>(context);
    if(!userSession.isLoggedIn){
      return _userCard(context,
        gpOnTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PackageScreen(userId: userSession.userId!),)),
        favOnTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationScreen(),)),
      );
    }
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserInitial) {
          context.read<UserBloc>().add(GetUserById(userSession.userId!));
          return _buildShimmerEffect();
        } else if (state is UserLoading) {
          return _buildShimmerEffect();
        } else if (state is UserLoaded) {
            final user = state.user;
          return _userCard(context,
            profileImage: NetworkImage(user.profilePhoto.toString()),
            name: user.fullName,
            des: 'Pune pin- 411028, Maharashtra',
            pgColor: user.packageActive == true ? CustomColor.whiteColor:  CustomColor.whiteColor,
            gpOnTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PackageScreen(userId: user.id),)),
            favOnTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationScreen(),)),
          );
        } else if (state is UserError) {
          print("Error: ${state.massage}");
        }
        return const SizedBox();
      },
    );
  }
}

Widget _userCard(BuildContext context, {ImageProvider<Object>? profileImage, String? name, String? des, VoidCallback? gpOnTap, VoidCallback? favOnTap, Color? pgColor}){
  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: Row(
          children: [
            CircleAvatar(radius: 20.5,
              backgroundColor: CustomColor.appColor,
              child: CircleAvatar(
                radius: 20,
                backgroundColor: CustomColor.whiteColor,
                backgroundImage: profileImage ?? AssetImage(CustomImage.nullImage),
              ),
            ),
            10.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name ?? 'Guest',style: textStyle14(context, color: CustomColor.whiteColor),),
                  Text(des ?? getGreeting(), style: textStyle12(context, fontWeight: FontWeight.w400, color: CustomColor.blackColor,), overflow: TextOverflow.ellipsis,),
                ],
              ),
            ),
          ],
        ),
      ),

      Row(
        children: [
          InkWell(
            onTap: gpOnTap,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              decoration: BoxDecoration(border: Border.all(color: CustomColor.appColor, width: 0.5), borderRadius: BorderRadius.circular(10),),
              child:  Row(
                children: [
                  Icon(Icons.verified_outlined, size: 16, color: pgColor ?? Colors.white,),
                  10.width,
                  Text('GP',
                      style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
                ],
              ),
            ),
          ),
          10.width,
          IconButton(
            onPressed: favOnTap,
            icon: const Icon(Icons.notifications_active_outlined, color: Colors.white, ),
          ),
        ],
      ),
    ],
  );
}

Widget _buildShimmerEffect() {
  return   Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(radius: 20, backgroundColor: Colors.grey.shade300),
           10.width,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(height: 10, width: 60,),
                5.height,
                ShimmerBox(height: 12, width: 100,),
              ],
            ),
          ],
        ),
        Row(
          children: [
            ShimmerBox(height: 25, width: 60,),
            20.width,
            Icon(Icons.notifications, color: Colors.grey.shade300),
           20.width,
          ],
        ),
      ],
    ),
  );
}

