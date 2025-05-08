import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';
import 'package:bizbooster2x/core/widgets/custom_headline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screen/understanding_bizbooster_screen.dart';

class UnderstandingBizBoosterWidget extends StatelessWidget {
  const UnderstandingBizBoosterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
            child: Text('Understanding BizBooster', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),),
          ),
          SizedBox(
            height: 210,
            child: ListView.builder(
              itemCount: 5,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
              return CustomContainer(
                width: 150, backgroundColor: Colors.white,
                margin: EdgeInsets.only(left: 15, bottom: 10),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => UnderstandingBizBoosterScreen(),)),
              );
            },),
          )
        ],
      ),
    );
  }
}
