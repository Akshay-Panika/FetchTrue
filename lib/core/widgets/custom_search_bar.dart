import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'custom_container.dart';
import 'custom_search_icon.dart';

class CustomSearchBar extends StatelessWidget {
  final VoidCallback? onTap;
  const CustomSearchBar({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      onTap: onTap,
      backgroundColor: Colors.white,
      border: true,
      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Search here..."),
          CustomSearchIcon(),
        ],
      ),
    );
  }
}
