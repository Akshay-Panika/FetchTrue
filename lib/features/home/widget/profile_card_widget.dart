import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/features/favorite/screen/favorite_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';
import '../../package/screen/package_screen.dart';

class ProfileCardWidget extends StatelessWidget {
  const ProfileCardWidget({super.key,});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      margin: EdgeInsets.all(0),
      backgroundColor: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            spacing: 10,
            children: [
              CircleAvatar(radius: 25,
                backgroundColor: Colors.white,
                backgroundImage: AssetImage('assets/image/Null_Profile.jpg'),
               ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Akshay !', style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),
                  Text('Good Morning'),
                ],
              ),
            ],
          ),

          Row(
            children: [
              InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PackageScreen(),)),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: CustomColor.appColor, width: 0.5),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Row(
                    spacing: 5,
                    children: [
                      Icon(Icons.leaderboard_outlined, size: 16,),
                      Text('GP', style: TextStyle(fontWeight: FontWeight.w600),)
                    ],
                  ),
                ),
              ),
              SizedBox(width: 20,),

              IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FavoriteScreen())), icon: Icon(Icons.favorite_border,))
            ],
          )

        ],
      ),
    );
  }
}
