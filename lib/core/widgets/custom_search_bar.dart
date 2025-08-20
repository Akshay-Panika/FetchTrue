import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/feature/search/screen/search_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../feature/auth/user_notifier/user_notifier.dart';
import '../../feature/favorite/screen/favorite_screen.dart';
import 'custom_container.dart';
import 'custom_search_icon.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key,});

  @override
  Widget build(BuildContext context) {
    final userSession = Provider.of<UserSession>(context);

    return Row(
      children: [
        Expanded(
          child: CustomContainer(
            color: Colors.white,
            border: true,
            borderColor: CustomColor.appColor,
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Search here..."),
                CustomSearchIcon(),
              ],
            ),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen(),)),
          ),
        ),

        CustomContainer(
          border: true,
          borderColor: CustomColor.appColor,
          color: CustomColor.whiteColor,
          padding: EdgeInsets.all(8),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FavoriteScreen(userId: userSession.userId),)),
          child: Icon(Icons.favorite, color: Colors.red,),),
      ],
    );
  }
}
