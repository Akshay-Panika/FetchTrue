import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';
import '../../favorite/screen/favorite_screen.dart';
import '../../notification/screen/notification_screen.dart';
import '../../package/screen/package_screen.dart';

class ProfileCardWidget extends StatelessWidget {
  const ProfileCardWidget({super.key});

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
      child: Row(
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
                  Text('Akshay !', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  Text(getGreeting(), style: textStyle14(context,fontWeight: FontWeight.w400, color: CustomColor.appColor),),
                ],
              ),
            ],
          ),
          Row(
            children: [
              InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PackageScreen())),
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
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => NotificationScreen())),
                icon: Icon(Icons.notifications_active_outlined),
              )
            ],
          )
        ],
      ),
    );
  }
}
