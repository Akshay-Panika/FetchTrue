import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'custom_container.dart';

class CustomSearchBar extends StatelessWidget {
  final VoidCallback? onTap;
  const CustomSearchBar({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      onTap: onTap,
      backgroundColor: Colors.white,
      border: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Search here..."),
          Icon(CupertinoIcons.search, color: Colors.black54,)
        ],
      ),
    );
  }
}
