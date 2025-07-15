import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/feature/more/model/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';
import '../../notification/screen/notification_screen.dart';
import '../../package/screen/package_screen.dart';

class ProfileAppWidget extends StatefulWidget {
  final UserModel? userdata;
  final bool isLoading;
  const ProfileAppWidget({super.key, this.userdata, required this.isLoading});

  @override
  State<ProfileAppWidget> createState() => _ProfileAppWidgetState();
}

class _ProfileAppWidgetState extends State<ProfileAppWidget> {
  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }


  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      margin: EdgeInsets.all(0),
      backgroundColor: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: widget.isLoading
          ? _buildShimmerEffect()
          : Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white,
                backgroundImage: AssetImage(CustomImage.nullImage),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.userdata?.fullName ?? 'User Name',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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
          Row(
            children: [
              InkWell(
                onTap: () => Navigator.push(
                    context, MaterialPageRoute(builder: (_) => PackageScreen())),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: CustomColor.appColor, width: 0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.leaderboard_outlined, size: 16),
                      SizedBox(width: 5),
                      Text('GP', style: TextStyle(fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 20),
              IconButton(
                onPressed: () => Navigator.push(
                    context, MaterialPageRoute(builder: (_) => NotificationScreen())),
                icon: Icon(Icons.notifications_active_outlined),
              )
            ],
          )
        ],
      ),
    );
  }

}

Widget _buildShimmerEffect() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          CircleAvatar(radius: 25, backgroundColor: Colors.grey.shade300),
          10.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomContainer(height: 10, width: 60, backgroundColor: Colors.grey.shade300, padding: EdgeInsets.zero,margin: EdgeInsets.zero,),
              5.height,
              CustomContainer(height: 12, width: 100, backgroundColor: Colors.grey.shade300, padding: EdgeInsets.zero,margin: EdgeInsets.zero,),
            ],
          ),
        ],
      ),
      Row(
        children: [
          CustomContainer(height: 25, width: 60, backgroundColor: Colors.grey.shade300, padding: EdgeInsets.zero,margin: EdgeInsets.zero,),
         20.width,
          Icon(Icons.notifications, color: Colors.grey.shade300),
          20.width,
        ],
      ),
    ],
  );
}
