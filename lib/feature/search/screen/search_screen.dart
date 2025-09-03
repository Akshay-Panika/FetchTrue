import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_search_icon.dart';


class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return Scaffold(
      appBar: AppBar(toolbarHeight: 10,),

      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            child: Row(
              children: [
                Expanded(
                  child: Hero(
                    tag: "searchBarHero",
                    child: Material(
                      color: Colors.transparent,
                      child: CustomContainer(
                        margin: EdgeInsets.zero,
                        padding: EdgeInsets.symmetric(
                          horizontal: dimensions.screenWidth * 0.030,
                          vertical: dimensions.screenHeight * 0.01,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                autofocus: false, // ab smoothly Hero ke baad keyboard open hoga
                                decoration: InputDecoration(
                                  hintText: 'Search here...',
                                  hintStyle: textStyle14(context, fontWeight: FontWeight.w400),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                            CustomSearchIcon(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                10.width,
                IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close))
              ],
            ),
          ),
        ],
      ),

    );
  }
}
