import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/widgets/custom_container.dart';
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
            child: Text('Understanding Fetch True', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),),
          ),
          SizedBox(
            height: 210,
            child: ListView.builder(
              itemCount: 3,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
              return CustomContainer(
                width: 150, backgroundColor: Colors.white,
                margin: EdgeInsets.only(left: 15, bottom: 10),
                padding: EdgeInsets.zero,
                assetsImg: CustomImage.nullImage,
                child: Card.filled(
                  margin: EdgeInsets.zero,
                  shape: OutlineInputBorder(
                      borderSide: BorderSide(color: CustomColor.appColor, width: 0.2),
                      borderRadius: BorderRadius.circular(10,)),
                  color: Colors.black.withOpacity(0.1),
                  child: Icon(Icons.play_circle,color: CustomColor.whiteColor, size: 40,),
                ),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => UnderstandingBizBoosterScreen(),)),
              );
            },),
          )
        ],
      ),
    );
  }
}
