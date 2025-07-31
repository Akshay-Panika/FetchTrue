import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/feature/profile/model/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../../notification/screen/notification_screen.dart';
import '../../package/screen/package_screen.dart';


class ProfileAppWidget extends StatelessWidget {
  const ProfileAppWidget({super.key});

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final userSession = Provider.of<UserSession>(context);

    return CustomContainer(
      margin: EdgeInsets.zero,
      backgroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// 👤 User Info
          Row(
            children: [
               CircleAvatar(
                radius: 25,
                 backgroundColor: CustomColor.greyColor.withOpacity(0.2),
                 backgroundImage: AssetImage(CustomImage.nullImage),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userSession.isLoggedIn
                        ? "${userSession.name}"
                        : "Guest",
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    getGreeting(),
                    style: textStyle14(
                      context,
                      fontWeight: FontWeight.w400,
                      color: CustomColor.appColor,
                    ),
                  ),
                ],
              ),
            ],
          ),

          /// ⚙️ Actions
          Row(
            children: [
              InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) =>  PackageScreen(userId: userSession.userId!,)),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: CustomColor.appColor, width: 0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.leaderboard_outlined, size: 16),
                      SizedBox(width: 5),
                      Text('GP', style: TextStyle(fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 20),
              IconButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NotificationScreen()),
                ),
                icon: const Icon(Icons.notifications_active_outlined),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// ✅ Shimmer loader while fetching user
Widget _buildShimmerEffect() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          CircleAvatar(radius: 25, backgroundColor: Colors.grey.shade300),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomContainer(
                height: 10,
                width: 60,
                backgroundColor: Colors.grey.shade300,
                padding: EdgeInsets.zero,
                margin: EdgeInsets.zero,
              ),
              const SizedBox(height: 5),
              CustomContainer(
                height: 12,
                width: 100,
                backgroundColor: Colors.grey.shade300,
                padding: EdgeInsets.zero,
                margin: EdgeInsets.zero,
              ),
            ],
          ),
        ],
      ),
      Row(
        children: [
          CustomContainer(
            height: 25,
            width: 60,
            backgroundColor: Colors.grey.shade300,
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
          ),
          const SizedBox(width: 20),
          Icon(Icons.notifications, color: Colors.grey.shade300),
          const SizedBox(width: 20),
        ],
      ),
    ],
  );
}

