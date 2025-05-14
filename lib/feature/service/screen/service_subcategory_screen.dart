import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';
import 'package:bizbooster2x/feature/service/screen/service_details_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ServiceSubcategoryScreen extends StatelessWidget {
  final String headline;
   ServiceSubcategoryScreen({super.key, required this.headline});

  final List<Map<String, String>> serviceData = [
    {
      'image' : 'assets/image/thumbnail1.png'
    },
    {
      'image' : 'assets/image/thumbnail2.png'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '$headline',showBackButton: true,showSearchIcon: true,),

      body: SafeArea(
        child: Column(
          crossAxisAlignment:CrossAxisAlignment.start,
          children: [

            /// Service type
            Expanded(
              child: CustomContainer(
                backgroundColor: Colors.transparent,
                padding: EdgeInsets.all(0),
                margin: EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  children: [




                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
