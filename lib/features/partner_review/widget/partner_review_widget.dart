import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/custom_container.dart';
import '../screen/partner_review_screen.dart';

class PartnerReviewWidget extends StatelessWidget {
  const PartnerReviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue.shade50.withOpacity(0.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
            child: Text('Partner Review', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),),
          ),
          SizedBox(
            height: 180,
            child: ListView.builder(
              itemCount: 5,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return CustomContainer(
                  border: true,
                  width: 300, backgroundColor: Colors.white,
                  margin: EdgeInsets.only(left: 15, bottom: 10),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PartnerReviewScreen(),)),
                );
              },),
          )
        ],
      ),
    );
  }
}
