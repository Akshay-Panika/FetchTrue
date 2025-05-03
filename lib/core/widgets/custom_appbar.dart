import 'package:bizbooster2x/features/search/screen/search_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../features/cart/screen/cart_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final bool showBackButton;
  final bool showNotificationIcon;
  final bool showCartIcon;
  final bool showSearchIcon;
  final Widget? leading;
  final double? leadingWidth;

  const CustomAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.showBackButton = false,
    this.showNotificationIcon = false,
    this.showCartIcon = false,
    this.showSearchIcon = false,
    this.leading,
    this.leadingWidth,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: showBackButton ?
      IconButton(
        icon:  Icon(CupertinoIcons.back),
        onPressed: () => Navigator.of(context).pop(),
      ) : leading,
      leadingWidth: leadingWidth,
      title:  title != null ?Text(title!):titleWidget,
      actions:  [
        if(showNotificationIcon)
        IconButton(
          onPressed: null,
          icon: Icon(Icons.notifications_active_outlined,color: Colors.black87,),
        ),
        if(showCartIcon)
        IconButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CartScreen(),)),
          icon: Icon(Icons.shopping_cart_outlined,color: Colors.black87,),
        ),
        if(showSearchIcon)
        IconButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen(),)),
          icon: Icon(CupertinoIcons.search,color: Colors.black87,),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
