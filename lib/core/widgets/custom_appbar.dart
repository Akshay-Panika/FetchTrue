import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: showBackButton ? IconButton(
        icon:  Icon(CupertinoIcons.back),
        onPressed: () => Navigator.of(context).pop(),
      ) : null,
      title: Text(title),
      actions: const [
        IconButton(
          onPressed: null,
          icon: Icon(Icons.notifications_active_outlined,color: Colors.black87,),
        ),
        IconButton(
          onPressed: null,
          icon: Icon(Icons.shopping_cart_outlined,color: Colors.black87,),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
