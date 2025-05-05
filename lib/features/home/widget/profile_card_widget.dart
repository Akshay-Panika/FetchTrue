import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';

class ProfileCardWidget extends StatelessWidget {
  const ProfileCardWidget({super.key,});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      margin: EdgeInsets.all(0),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            spacing: 10,
            children: [
              CircleAvatar(radius: 25,backgroundColor: Colors.white,child: Icon(Icons.person,color: Colors.grey[500],),),
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
              CustomContainer(
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Row(
                  spacing: 5,
                  children: [
                    Icon(Icons.leaderboard_outlined, size: 16,),
                    Text('Silver', style: TextStyle(fontWeight: FontWeight.w600),)
                  ],
                ),
              ),
              IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Scaffold(appBar: CustomAppBar(title: 'Favorite',showBackButton: true,),),)), icon: Icon(Icons.favorite_border,))
            ],
          )

        ],
      ),
    );
  }
}
